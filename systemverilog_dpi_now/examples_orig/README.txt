---------------------------------------
Files contained here work on 
  ModelSim 6.0c (SystemVerilog 3.1a compliant) and 
  ModelSim 6.1 BETA (P1800 compliant).
---------------------------------------

All examples run on linux with gcc. 
Others may work, but are untested.

To run the examples:

  1. Setup a path to ModelSim install area: (The makefiles assume MTI_HOME
     is the name of the ModelSim install area).

	  setenv MTI_HOME <PLACE_WHERE_MODELSIM_INSTALLED>

      set path = ( $MTI_HOME/linux $path )

     where MTI_HOME is the directory that contains the "RELEASE_NOTES"
	 file, and the directory for your platform (linux in this case).

	 After you do that, 'vlog', and 'vsim' should be in your path.

	   which vlog
	   which vsim

  2. Make sure you have a C compiler in your path. (gcc preferred and tested).

  3. Run EVERYTHING

     make tools
	 make

  4. Run one thing at a time. CD to the directory, and type 'make'.

     cd golden
	 make


---------------------------------------
Other useful 'make' target:
---------------------------------------

  make all

    Build and run the main targets.


  make clean

  	Remove most generated files.
 

  make cleanall

    Remove all generated files. Put the files back into 
	a "distribution clean" state.

 
  make tools

    Build supporting libraries, like zlib, or EGGX.


---------------------------------------
File List
---------------------------------------

./README.txt

./makefile
./makefile.inc

./abstraction-reuse
  ./abstraction-reuse/makefile
  ./abstraction-reuse/ccode.c
  ./abstraction-reuse/vlcode.v

./external-model
  ./external-model/makefile
  ./external-model/ccode.c
  ./external-model/vlcode.v

./golden
  ./golden/makefile
  ./golden/ccode.c
  ./golden/vlcode.v

./software
  ./software/makefile
  ./software/ccode.c
  ./software/vlcode.v

./user-interface
  ./user-interface/makefile
  ./user-interface/ccode.c
  ./user-interface/vlcode.v

    ./user-interface/draw
    ./user-interface/draw/draw.c
    ./user-interface/draw/draw.h
    ./user-interface/draw/EGGX080.tar.gz
    ./user-interface/draw/makefile
    ./user-interface/draw/mandel.c
    ./user-interface/draw/README.txt
    
./utility-library
  ./utility-library/makefile
  ./utility-library/ccode.c
  ./utility-library/vlcode.v

./vector-file
  ./vector-file/README.txt
  ./vector-file/makefile
  ./vector-file/ccode.c
  ./vector-file/vlcode.v

    ./vector-file/compressed.txt.gz
    ./vector-file/configure.zlib.mti
    ./vector-file/zlib-1.2.1.tar.gz
