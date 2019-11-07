# Time-stamp: <2019-01-22 13:36:55 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
include $(GIT_ROOT)/makefile

default:
	@$(MAKE) nim nc FILES="module_1.sv module_2.sv"
