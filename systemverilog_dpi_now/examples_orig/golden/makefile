all: run

include ../makefile.inc

run:
	rm -rf work
	vlib work
	vlog -dpiheader dpiheader.h -sv vlcode.v
	gcc $(CFLAGS) -I$(MTI_HOME)/include -I. -o ccode.so ccode.c
	time vsim -c -sv_lib ccode top -do "run -all; quit -f"
