import std/[strformat]
import svdpi

proc f_logic_sv(i: svLogic; oPtr, ioPtr: ptr svLogic): svLogic {.importc.}

proc f_logic_nim(i: svLogic; oPtr, ioPtr: ptr svLogic): svLogic {.exportc, dynlib.} =
  echo &"f_logic_nim: Init: i={i}, o={oPtr[]}, io={ioPtr[]}"
  oPtr[] = i + 1
  ioPtr[] = oPtr[] + 1 # io (ioPtr) is output here
  echo &"f_logic_nim: Before calling f_logic_sv: i={i}, o={oPtr[]}, io={ioPtr[]}"
  # Interestingly, as the svLogic type is actually uint8, values above
  # can go above the value of 1, unlike the actual logic vars in SV.
  let
    svRet = f_logic_sv(i, oPtr, ioPtr)
  echo &"f_logic_nim: After calling f_logic_sv: svRet={svRet}, i={i}, o={oPtr[]}, io={ioPtr[]}"
  return ioPtr[] + 1
