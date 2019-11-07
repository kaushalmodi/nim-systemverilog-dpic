# Time-stamp: <2019-04-26 17:48:17 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
include $(GIT_ROOT)/makefile

# Compiles to C
default: nim nc

# Compiles to C++
cpp:
	$(MAKE) libdpi NIM_COMPILES_TO=cpp
	$(MAKE) nc
