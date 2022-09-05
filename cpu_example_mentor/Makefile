# Time-stamp: <2021-05-06 00:23:50 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)
FILES ?= *.v
NIM_MM ?= arc

# For veriuser.h
NIM_SWITCHES += --passC="-I$(XCELIUM_ROOT)/../include"

include $(GIT_ROOT)/makefile

check:
	diff -qr logs/ orig/logs

default: nimcpp nc check
