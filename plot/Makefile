# Time-stamp: <2019-11-04 11:36:10 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

NIM_GC = --gc:none
include $(GIT_ROOT)/makefile

default: libdpi nc

ggplot:
	$(MAKE) libdpi NIM_DEFINES=-d:useGgplot
	$(MAKE) nc
