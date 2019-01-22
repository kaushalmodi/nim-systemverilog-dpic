all: run

include ../makefile.inc

# Place that is HERE.
ZLIB = ./zlib-1.2.1
ZLIB_LIB = $(ZLIB)/$(PLATFORM)/lib

run:
	rm -rf work
	vlib work
	vlog -dpiheader dpiheader.h -sv vlcode.v
	gcc $(CFLAGS) -I$(ZLIB)/include -I$(MTI_HOME)/include -I. \
		-o ccode.so ccode.c 
	time vsim -c \
			-sv_root $(ZLIB_LIB) \
			-sv_lib libz \
			-sv_root . \
			-sv_lib ccode \
		top -do "run -all; quit -f"

cleanall:: clean
	cd $(ZLIB); make clean
	rm -rf $(ZLIB) 

tools:
	tar xvfz $(ZLIB).tar.gz
	cd $(ZLIB); ../configure.zlib.mti; make; make install
