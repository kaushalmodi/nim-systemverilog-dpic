import std/[strformat]
import svdpi

var
  hereCounter: cint = 0
  enable: cint = 1

proc hereDebug(initVal: cint; enableSticky: cint; realVal: cdouble): cstring {.exportc.} =
  if enableSticky >= 0:
    enable = enableSticky
  if enable > 0:
    if initVal >= 0:
      hereCounter = initVal
    result = &"@{realVal} <{hereCounter}> I am in `{svGetNameFromScope(svGetScope())}' :HERE:"
    hereCounter += 1
