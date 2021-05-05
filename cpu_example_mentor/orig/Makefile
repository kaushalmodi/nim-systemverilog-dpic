##
## -------------------------------------------------------------
##    Copyright 2011 Mentor Graphics, Inc.
##    All Rights Reserved Worldwide
##
##    Licensed under the Apache License, Version 2.0 (the
##    "License"); you may not use this file except in
##    compliance with the License.  You may obtain a copy of
##    the License at
##
##        http://www.apache.org/licenses/LICENSE-2.0
##
##    Unless required by applicable law or agreed to in
##    writing, software distributed under the License is
##    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##    CONDITIONS OF ANY KIND, either express or implied.  See
##    the License for the specific language governing
##    permissions and limitations under the License.
## -------------------------------------------------------------
##

.DEFAULT_GOAL := xrun

all: sim

#---------------------------------------------------------------



SRC = system.v risc.v dsp2.v dsp3.sv memory.v dsp2.c memory.c risc.c

work:
	vlib work

system: $(SRC) work
	vlog -sv $(SRC) -ccflags -g -dpiheader risc.h

sim:	$(SRC) system
	vsim -c system

gui:	$(SRC) system
	vsim -voptargs=+acc system -i

clean:
	rm -rf *~ *.log work wlf* *wlf *.dll *.o *.out *.so xcelium.d/ xrun.*

xrun:
	xrun -sv *.v *.sv *.c
