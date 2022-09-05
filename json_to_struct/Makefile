# Time-stamp: <2022-09-05 14:43:34 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
NIM_MM ?= arc

include $(GIT_ROOT)/makefile

default: nimcpp nc

jsony:
	$(MAKE) nimcpp nc NIM_DEFINES+="-d:jsony -d:release"
