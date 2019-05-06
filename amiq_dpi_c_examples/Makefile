# Time-stamp: <2019-05-06 12:10:58 kmodi>

.DEFAULT_GOAL := default

NIM_GC = --gc:regions

GIT_ROOT = $(shell git rev-parse --show-toplevel)
include $(GIT_ROOT)/makefile

# Compiles to C
default: libdpi nc

# Compiles to C++
cpp:
	$(MAKE) libdpi NIM_COMPILES_TO=cpp
	$(MAKE) nc
