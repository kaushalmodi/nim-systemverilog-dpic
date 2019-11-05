# Time-stamp: <2019-11-05 12:06:39 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

NIM_GC = --gc:regions
include $(GIT_ROOT)/makefile

default: libdpi nc

gcdbg:
	$(MAKE) libdpi NIM_GC= NIM_DEFINES=--debugger:native
	$(MAKE) ncgdb

ggplot:
	$(MAKE) libdpi NIM_DEFINES=-d:useGgplot
	$(MAKE) nc
