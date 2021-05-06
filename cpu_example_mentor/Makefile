# Time-stamp: <2021-05-05 21:46:18 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
FILES ?= orig/*.sv orig/*.v
NIM_GC ?= arc
ARCH ?= 32

# For veriuser.h
NIM_SWITCHES += --passC="-I$(XCELIUM_ROOT)/../include"

include $(GIT_ROOT)/makefile

default: nimcpp nc
