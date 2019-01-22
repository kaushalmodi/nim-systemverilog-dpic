import svdpi
import strformat

proc FROM_SV(in1, in2: cint; out1: var cint) {.importc.}


proc TO_SV_TASK(inp1, inp2: cint; c_answer: var cint): cint {.exportc.} =
  return 0 # tasks send a return value of 0

proc TO_SV_FUNC(inp1, inp2: cint; c_answer: var cint) {.exportc.} =
