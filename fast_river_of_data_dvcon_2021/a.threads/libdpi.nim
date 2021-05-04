import std/[strformat]

# Tasks always have an int return type on the C side.
proc t_int_sv(threadName: cstring; i: cint; o, io: ptr cint): cint {.importc.}

proc t_int_nim(threadName: cstring; i: cint; oPtr, ioPtr: ptr cint): cint {.exportc, dynlib.} =
  oPtr[] = i + 1
  ioPtr[] = oPtr[] + 1
  echo &"Hello from t_int_nim (before SV call): {threadName}:: i={i}, o={oPtr[]}, io={ioPtr[]}"
  discard t_int_sv(threadName, i, oPtr, ioPtr)
  echo &"Hello from t_int_nim (after SV call): {threadName}:: i={i}, o={oPtr[]}, io={ioPtr[]}"
  return 0
