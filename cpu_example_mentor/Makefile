# Time-stamp: <2021-05-05 17:11:19 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
FILES ?= orig/*.sv orig/*.v
NIM_GC ?= arc

# For veriuser.h
NIM_SWITCHES += --gcc.options="-I$(XCELIUM_ROOT)/../include"
NIM_SWITCHES += --gcc.cpp.options="-I$(XCELIUM_ROOT)/../include"

include $(GIT_ROOT)/makefile

default: nimcpp nc
