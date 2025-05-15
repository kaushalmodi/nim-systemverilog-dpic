# Time-stamp: <2025-05-15 15:35:55 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
NIM_MM = arc
# Thu Nov 07 16:23:47 EST 2019 - kmodi
# default (refc), boehm, destructors GC do not work

include $(GIT_ROOT)/makefile

# https://github.com/Vindaar/ggplotnim/issues/133#issuecomment-1047030631
NIM_DEFINES += -d:nolapack

default: nim nc
