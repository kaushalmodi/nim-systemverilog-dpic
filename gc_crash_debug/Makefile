# Time-stamp: <2019-11-07 11:02:28 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

include $(GIT_ROOT)/makefile

default: nim nc

gdb:
	$(MAKE) GDB=1

gcnone:
	$(MAKE) NIM_GC=--gc:none

gcdefault:
	$(MAKE) NIM_GC=
