# Time-stamp: <2021-05-05 16:43:41 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
FILES ?= orig/*.sv orig/*.v
NIM_GC ?= arc

# Wed May 05 16:18:35 EDT 2021 - kmodi
# FIXME: Debug why ARCH=64 run crashes.
ARCH ?= 32

# For veriuser.h
NIM_SWITCHES += --gcc.options="-I$(XCELIUM_ROOT)/../include"
NIM_SWITCHES += --gcc.cpp.options="-I$(XCELIUM_ROOT)/../include"

include $(GIT_ROOT)/makefile

default: nimcpp nc
