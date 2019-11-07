# Time-stamp: <2019-11-07 16:19:54 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
NIM_GC = boehm

include $(GIT_ROOT)/makefile

# Compiles to C
default: nim nc

# Compiles to C++
cpp: nimcpp nc
