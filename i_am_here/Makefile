# Time-stamp: <2019-11-05 14:17:16 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
include $(GIT_ROOT)/makefile

default:
	$(MAKE) nim nc UVM=1
