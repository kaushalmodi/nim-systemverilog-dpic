# Time-stamp: <2021-05-04 09:35:49 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
NIM_MM ?= arc
NC_SWITCHES ?= -access +rwc # for probing for waves

include $(GIT_ROOT)/makefile

default: nimcpp nc
