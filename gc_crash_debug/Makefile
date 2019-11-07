# Time-stamp: <2019-11-07 10:41:35 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

include $(GIT_ROOT)/makefile

default: nim nc

valg:
	$(MAKE) nim GDB=1
	$(MAKE) nc VALG=1

gdb:
	$(MAKE) GDB=1

gcnone:
	$(MAKE) NIM_GC=--gc:none

gcdefault:
	$(MAKE) NIM_GC=
