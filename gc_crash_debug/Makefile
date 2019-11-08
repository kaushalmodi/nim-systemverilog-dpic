# Time-stamp: <2019-11-08 10:31:33 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

include $(GIT_ROOT)/makefile

default: nim nc

# Use the default GC, but disable it while the Nim exportc'd proc is
# running. This will be effectively the same as running with
# --gc:none.
gctoggle:
	$(MAKE) nim NIM_GC= NIM_DEFINES+=-d:gcToggle
	$(MAKE) nc
