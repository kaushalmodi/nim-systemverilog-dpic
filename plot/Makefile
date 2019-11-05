# Time-stamp: <2019-11-05 09:29:31 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

NIM_GC = --gc:regions
include $(GIT_ROOT)/makefile

default: libdpi nc

ggplot:
	$(MAKE) libdpi NIM_DEFINES=-d:useGgplot
	$(MAKE) nc
