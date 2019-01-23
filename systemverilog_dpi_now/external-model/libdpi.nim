import svdpi
import strformat

proc vl_posedge_clk() {.importc.}

var
  mem: array[4096, int16]


proc c_store(address: int32; data: int16): cint {.exportc.} =
  vl_posedge_clk()
  mem[address] = data

  return 0 # tasks send a return value of 0

proc c_retrieve(address: int32; data: var int16): cint {.exportc.} =
  vl_posedge_clk()
  data = mem[address]

  return 0 # tasks send a return value of 0
