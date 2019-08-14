import std/[strformat]
import svdpi

var
  hereCounter: cint = 0
  enable: cint = 1

template hereDebugTmpl(body: untyped) {.dirty.} =
  if enableSticky >= 0:
    enable = enableSticky
  if enable > 0:
    if initVal >= 0:
      hereCounter = initVal
    body
    hereCounter += 1

proc hereDebug(initVal: cint; enableSticky: cint; realVal: cdouble) {.exportc.} =
  hereDebugTmpl:
    echo &"[{realVal}] I am here {hereCounter}"

proc hereDebugCntxt(initVal: cint; enableSticky: cint; realVal: cdouble) {.exportc.} =
  hereDebugTmpl:
    echo &"[{realVal}] I am here {hereCounter} in {svGetNameFromScope(svGetScope())}"
