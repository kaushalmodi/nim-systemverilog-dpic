import std/[strformat]
import svdpi

proc FROM_SV_TASK(in1, in2: cint; out1: var cint): cint {.importc, discardable.}

proc FROM_SV_FUNC(in1, in2: cint; out1: var cint) {.importc.}


proc TO_SV_TASK(in1, in2: cint; out1: var cint): cint {.exportc, dynlib.} =
  echo "Exported to SV task"
  return 0 # tasks send a return value of 0

proc TO_SV_FUNC(in1, in2: cint; out1: var cint){.exportc, dynlib.} =
  echo "Exported to SV function"


proc TO_SV_TASK_c(in1, in2: cint; out1: var cint): cint {.exportc, dynlib.} =
  FROM_SV_TASK(in1, in2, out1)
  return 0 # tasks send a return value of 0

proc TO_SV_FUNC_c(in1, in2: cint; out1: var cint){.exportc, dynlib.} =
  FROM_SV_FUNC(in1, in2, out1)
