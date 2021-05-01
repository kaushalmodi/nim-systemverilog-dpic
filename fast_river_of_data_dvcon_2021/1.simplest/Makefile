# Time-stamp: <2019-11-07 15:06:35 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
include $(GIT_ROOT)/makefile

# Compiles to C
default: nim nc

# Compiles to C++
cpp: nimcpp nc
