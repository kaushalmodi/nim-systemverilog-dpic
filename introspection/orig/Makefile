.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

FILES ?= VPI_pkg.sv tb.sv

include $(GIT_ROOT)/makefile

default: clean clibdpi nc
