# Time-stamp: <2019-11-07 14:52:25 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

include $(GIT_ROOT)/makefile

default: nim nc

gdb:
	$(MAKE) GDB=1
