# Time-stamp: <2019-11-07 14:50:40 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
include $(GIT_ROOT)/makefile

NIM_GC = boehm

# Compiles to C
default: nim nc

# Compiles to C++
cpp:
	$(MAKE) libdpi NIM_COMPILES_TO=cpp
	$(MAKE) nc
