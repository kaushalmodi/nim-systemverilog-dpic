import std/[strformat]
import svdpi

var
  hereCounter: cint = 0

proc hereDebug(initVal: cint; realVal: cdouble): cstring {.exportc, dynlib.} =
  if initVal >= 0:
    hereCounter = initVal
  let
    realStr = if realVal >= 0.0:
                &"@{realVal} "
              else:
                ""
  result = &"{realStr}<{hereCounter}> I am in `{svGetNameFromScope(svGetScope())}'"
  hereCounter += 1
