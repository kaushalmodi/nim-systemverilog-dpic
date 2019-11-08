import svdpi

type
  # Alias Nim type "pointer" to "Chandle" just for better readability.
  Chandle = pointer

proc adder[T](args: openArray[T]): T =
  var
    idx = 0
  for arg in args:
    when T is cstring:
      result = cstring($result & $arg)
      if idx < args.high:
        result = cstring($result & " ")
    else:
      result = result + arg
    inc(idx)

proc getAdderProcHandle[T](): Chandle =
  ## Return pointer to a "C function type".
  return cast[Chandle](adder[T])

proc callProc[T](ch: Chandle; chArgsPtr: svOpenArrayHandle): T =
  ## Call the C function pointed by ``ch`` with args referenced by ``chArgsPtr``.
  let
    procInst = cast[type adder[T]](ch)
    args = svSVDynArr1ToSeq[T](chArgsPtr)
  return procInst(args)

## Exported Procs
proc getAdderProcHandleInt(): Chandle {.exportc.} =
  getAdderProcHandle[cint]()

proc callProcInt(ch: Chandle; chArgsPtr: svOpenArrayHandle): cint {.exportc.} =
  callProc[cint](ch, chArgsPtr)

proc getAdderProcHandleFloat(): Chandle {.exportc.} =
  getAdderProcHandle[cdouble]()

proc callProcFloat(ch: Chandle; chArgsPtr: svOpenArrayHandle): cdouble {.exportc.} =
  callProc[cdouble](ch, chArgsPtr)

proc getAdderProcHandleString(): Chandle {.exportc.} =
  getAdderProcHandle[cstring]()

proc callProcString(ch: Chandle; chArgsPtr: svOpenArrayHandle): cstring {.exportc.} =
  callProc[cstring](ch, chArgsPtr)
