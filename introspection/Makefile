# Time-stamp: <2021-05-13 02:25:56 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

NIM_GC ?= arc

FILES ?= ../svvpi/sv/vpi_pkg.sv tb.sv
NC_SWITCHES ?= -xmerror ENUMERR

include $(GIT_ROOT)/makefile

default: nimcpp nc
