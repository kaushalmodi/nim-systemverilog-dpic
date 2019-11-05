# Time-stamp: <2019-11-05 13:59:40 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

NIM_GC = --gc:regions
include $(GIT_ROOT)/makefile

default: nim nc

ggplot:
	$(MAKE) nim NIM_DEFINES="-d:useGgplot"
	$(MAKE) nc

dbg1:
	$(MAKE) NIM_GC= GDB=1
dbg2:
	$(MAKE) ggplot NIM_GC= GDB=1
