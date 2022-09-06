# Time-stamp: <2022-09-05 23:12:31 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
NIM_MM = arc

include $(GIT_ROOT)/makefile

# Compiles to C
default: nim nc

# Compiles to C++
cpp: nimcpp nc
