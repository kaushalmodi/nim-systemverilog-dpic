# Time-stamp: <2019-11-05 12:51:45 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

NIM_GC = --gc:regions
include $(GIT_ROOT)/makefile

default: libdpi nc

gcdbg:
	$(MAKE) libdpi NIM_GC= NIM_DEFINES="--debugger:native --gcc.options.debug=\"-O0 -g3 -ggdb3\""
	$(MAKE) ncgdb

ggplot:
	$(MAKE) libdpi NIM_DEFINES=-d:useGgplot
	$(MAKE) nc
