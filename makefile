# Time-stamp: <2019-08-14 09:06:16 kmodi>
# Author    : Kaushal Modi

FILES   ?= tb.sv
DEFINES	= DEFINE_PLACEHOLDER
# DSEM2009, DSEMEL: Don't keep on bugging by telling that SV 2009 is
#     being used. I know it already.
# SPDUSD: Don't warn about unused include dirs.
NOWARNS = -nowarn DSEM2009 -nowarn DSEMEL -nowarn SPDUSD
NC_SWITCHES = -clean

# Subdirs contains a list of all directories containing a "Makefile".
SUBDIRS = $(shell find . -name "Makefile" | sed 's|/Makefile||')

NIM ?= nim

ARCH ?= 64
ifeq ($(ARCH), 64)
	NIM_ARCH_FLAGS :=
	NIM_SO := libdpi_64.so
	NC_ARCH_FLAGS := -64bit
	GCC_ARCH_FLAG := -m64
else
	NIM_ARCH_FLAGS := --cpu:i386 --passC:-m32 --passL:-m32
	NIM_SO := libdpi_32.so
	NC_ARCH_FLAGS :=
	GCC_ARCH_FLAG := -m32
endif

DEFAULT_SV_LIB ?= libdpi.so
# Possible values of NIM_COMPILES_TO: c, cpp
NIM_COMPILES_TO ?= c
NIM_GC ?=
NIM_DEFINES ?= -d:release

.PHONY: clean libdpi nc clibdpi $(SUBDIRS) all

clean:
	rm -rf *~ core simv* urg* *.log *.history \#*.* *.dump .simvision/ waves.shm/ \
	core.* simv* csrc* *.tmp *.vpd *.key log temp .vcs* DVE* *~ \
	INCA_libs xcelium.d *.o ./.nimcache sigusrdump.out

# libdpi.nim -> libdpi.c -> $(DEFAULT_SV_LIB)
# --gc:none is needed else Nim tries to free memory allocated for
# arrays and stuff by the simulator on SV side.
# https://irclogs.nim-lang.org/21-01-2019.html#17:16:39
libdpi:
	@find . \( -name libdpi.o -o -name $(NIM_SO) \) -delete
	$(NIM) $(NIM_COMPILES_TO) --out:$(NIM_SO) --app:lib --nimcache:./.nimcache $(NIM_ARCH_FLAGS) $(NIM_GC) --hint[Processing]:off $(NIM_DEFINES) libdpi.nim

nc:
	ln -sf $(NIM_SO) $(DEFAULT_SV_LIB)
	xrun -sv $(NC_ARCH_FLAGS) \
	-timescale 1ns/10ps \
	+define+SHM_DUMP -debug \
	+define+$(DEFINES) \
	$(FILES) \
	+incdir+./ \
	$(NOWARNS) \
	$(NC_SWITCHES)

ncuvm:
	$(MAKE) nc NC_SWITCHES="-uvm -uvm -uvmhome CDNS-1.2 -clean"

# libdpi.c -> $(DEFAULT_SV_LIB)
# -I$(XCELIUM_ROOT)/../include for "svdpi.h"
clibdpi:
	@find . \( -name libdpi.o -o -name $(NIM_SO) \) -delete
	gcc -c -fPIC -I$(XCELIUM_ROOT)/../include libdpi.c $(GCC_ARCH_FLAG) -o libdpi.o
	gcc -shared -Wl,-soname,$(DEFAULT_SV_LIB) $(GCC_ARCH_FLAG) -o $(NIM_SO) libdpi.o
	@rm -f libdpi.o

# libdpi.cpp -> $(NIM_SO)
# -I$(XCELIUM_ROOT)/../include for "svdpi.h"
cpplibdpi:
	@find . \( -name libdpi.o -o -name $(NIM_SO) \) -delete
	g++ -c -fPIC -I$(XCELIUM_ROOT)/../include libdpi.cpp $(GCC_ARCH_FLAG) -o libdpi.o
	g++ -shared -Wl,-soname,$(DEFAULT_SV_LIB) $(GCC_ARCH_FLAG) -o $(NIM_SO) libdpi.o
	@rm -f libdpi.o

$(SUBDIRS):
	$(MAKE) -C $@

all: $(SUBDIRS)


# Run "make ARCH=32" to build 32-bit libdpi_32.so and run 32-bit xrun.
# Run "make" to build 64-bit libdpi_64.so and run 64-bit xrun.
