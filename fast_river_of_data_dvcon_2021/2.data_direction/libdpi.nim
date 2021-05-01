import std/[strformat]

proc f_int_sv(i: cint; oPtr, ioPtr: ptr cint): cint {.importc.}

proc f_int_nim(i: cint; oPtr, ioPtr: ptr cint): cint {.exportc, dynlib.} =
  echo &"f_int_nim: Init: i={i}, o={oPtr[]}, io={ioPtr[]}"
  oPtr[] = i + 1
  ioPtr[] = oPtr[] + 1 # io (ioPtr) is output here
  echo &"f_int_nim: Before calling f_int_sv: i={i}, o={oPtr[]}, io={ioPtr[]}"
  let
    svRet = f_int_sv(i, oPtr, ioPtr)
  echo &"f_int_nim: After calling f_int_sv: svRet={svRet}, i={i}, o={oPtr[]}, io={ioPtr[]}"
  return ioPtr[] + 1
