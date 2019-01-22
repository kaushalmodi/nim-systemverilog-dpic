all: run

include ../makefile.inc


run:
	rm -rf work
	vlib work
	vlog -dpiheader dpiheader.h -sv vlcode.v
	gcc $(CFLAGS) -Idraw -I$(MTI_HOME)/include -I. \
	   -o ccode.so ccode.c $(WINLIBS)
	time vsim -c \
		-gblso $(LIBX11)/libX11.so \
		-gblso draw/draw.so  \
		-sv_lib $(LIBX11)/libX11 \
		-sv_lib draw/draw \
		-sv_lib ccode \
		top -do "run -all; quit -f"

tools:
	cd draw; make tools
	cd draw/EGGX; make
	cd draw; make

cleanall:: clean
	cd draw; make cleanall
