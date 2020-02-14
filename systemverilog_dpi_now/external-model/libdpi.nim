import svdpi
import strformat

proc vl_posedge_clk() {.importc.}

var
  mem: array[4096, cshort]


proc c_store(address: cint; data: cshort): cint {.exportc, dynlib.} =
  vl_posedge_clk()
  mem[address] = data

  return 0 # tasks send a return value of 0

proc c_retrieve(address: cint; data: var cshort): cint {.exportc, dynlib.} =
  vl_posedge_clk()
  data = mem[address]

  return 0 # tasks send a return value of 0
