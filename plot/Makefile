# Time-stamp: <2019-11-07 14:54:05 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

include $(GIT_ROOT)/makefile

NIM_GC = regions

default: nim nc

ggplot:
	$(MAKE) nim NIM_DEFINES="-d:useGgplot"
	$(MAKE) nc

dbg1:
	$(MAKE) NIM_GC= GDB=1
dbg2:
	$(MAKE) ggplot NIM_GC= GDB=1
