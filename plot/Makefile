# Time-stamp: <2019-11-07 16:24:36 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
NIM_GC = regions
# Thu Nov 07 16:23:47 EST 2019 - kmodi
# default, boehm, destructors GC do not work

include $(GIT_ROOT)/makefile

default: nim nc

ggplot:
	$(MAKE) nim NIM_DEFINES="-d:useGgplot"
	$(MAKE) nc
