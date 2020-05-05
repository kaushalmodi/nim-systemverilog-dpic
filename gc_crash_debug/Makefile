# Time-stamp: <2020-03-13 00:04:36 kmodi>

.DEFAULT_GOAL := default

GIT_ROOT = $(shell git rev-parse --show-toplevel)

include $(GIT_ROOT)/makefile

default:
	$(MAKE) nim NIM_RELEASE=0 GDB=1
	$(MAKE) nc

# Use the default GC, but disable it while the Nim exportc'd proc is
# running. This will be effectively the same as running with
# --gc:none.
gctoggle:
	$(MAKE) nim NIM_GC= NIM_DEFINES+=-d:gcToggle
	$(MAKE) nc
