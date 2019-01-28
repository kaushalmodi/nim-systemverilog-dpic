# Time-stamp: <2019-01-28 14:08:57 kmodi>
# Author    : Kaushal Modi

FILES   = tb.sv
DEFINES	= DEFINE_PLACEHOLDER
# DSEM2009, DSEMEL: Don't keep on bugging by telling that SV 2009 is
#     being used. I know it already.
# SPDUSD: Don't warn about unused include dirs.
NOWARNS = -nowarn DSEM2009 -nowarn DSEMEL -nowarn SPDUSD
OPTIONS =

# Subdirs contains a list of all directories containing a "Makefile".
SUBDIRS = $(shell find . -name "Makefile" | sed 's|/Makefile||')

NIM_GC      = regions
NIM_DEFINES = -d:svdpi # used in the user-interface example

.PHONY: clean libdpi nc clibdpi $(SUBDIRS) all

clean:
	rm -rf *~ core simv* urg* *.log *.history \#*.* *.dump .simvision/ waves.shm/ \
	core.* simv* csrc* *.tmp *.vpd *.key log temp .vcs* *.txt DVE* *~ \
	INCA_libs xcelium.d *.so *.o ./.nimcache

# libdpi.nim -> libdpi.c -> libdpi.so
# --gc:none is needed else Nim tries to free memory allocated for
# arrays and stuff by the simulator on SV side.
# https://irclogs.nim-lang.org/21-01-2019.html#17:16:39
libdpi:
	@find . \( -name libdpi.o -o -name libdpi.so \) -delete
	nim c --out:libdpi.so --app:lib --nimcache:./.nimcache --gc:$(NIM_GC) $(NIM_DEFINES) libdpi.nim

nc:
	xrun -sv -64bit -timescale 1ns/10ps \
	+define+SHM_DUMP -debug \
	+define+$(DEFINES) \
	$(FILES) \
	+incdir+./ \
	$(NOWARNS) \
	$(OPTIONS)

# libdpi.c -> libdpi.so
# -I$(XCELIUM_ROOT)/../include for "svdpi.h"
clibdpi:
	@find . \( -name libdpi.o -o -name libdpi.so \) -delete
	gcc -c -fPIC -I$(XCELIUM_ROOT)/../include libdpi.c -m64 -o libdpi.o
	gcc -shared -Wl,-soname,libdpi.so -m64 -o libdpi.so libdpi.o
	@rm -f libdpi.o

$(SUBDIRS):
	$(MAKE) -C $@

all: $(SUBDIRS)
