import svdpi

type
  # Alias Nim type "pointer" to "Chandle" just for better readability.
  Chandle = pointer
  NimProc = enum
    nimAdder
    nimSubber

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

proc subber[T](args: openArray[T]): T =
  when T is cstring:
    echo "[Error] The subber proc does not support string args"
    return
  else:
    doAssert args.len >= 1
    result = args[0]
    for arg in args[1 .. args.high]:
      result = result - arg

proc getProcHandle[T](procEnum: NimProc): Chandle =
  ## Return pointer to a "C function type".
  case procEnum
  of nimSubber:
    result = cast[Chandle](subber[T])
  of nimAdder:
    result = cast[Chandle](adder[T])

proc callProc[T](ch: Chandle; procEnum: NimProc; chArgsPtr: svOpenArrayHandle): T =
  ## Call the C function pointed by ``ch`` with args referenced by ``chArgsPtr``.
  let
    procInst = case procEnum
               # Put the proc that has side effects (echo stmt in subber) first
               # so that procInst var gets declared as a proc var with
               # side effects.
               # https://stackoverflow.com/questions/53726458/nim-aliasing-procedures-with-side-effects#comment94308638_53726458
               of nimSubber:
                 cast[type subber[T]](ch)
               of nimAdder:
                 cast[type adder[T]](ch)
    args = svSVDynArr1ToSeq[T](chArgsPtr)
  return procInst(args)

## Exported Procs
proc getProcHandleInt(procEnum: NimProc): Chandle {.exportc, dynlib.} =
  getProcHandle[cint](procEnum)

proc callProcInt(ch: Chandle; procEnum: NimProc; chArgsPtr: svOpenArrayHandle): cint {.exportc, dynlib.} =
  callProc[cint](ch, procEnum, chArgsPtr)

proc getProcHandleFloat(procEnum: NimProc): Chandle {.exportc, dynlib.} =
  getProcHandle[cdouble](procEnum)

proc callProcFloat(ch: Chandle; procEnum: NimProc; chArgsPtr: svOpenArrayHandle): cdouble {.exportc, dynlib.} =
  callProc[cdouble](ch, procEnum, chArgsPtr)

proc getProcHandleString(procEnum: NimProc): Chandle {.exportc, dynlib.} =
  getProcHandle[cstring](procEnum)

proc callProcString(ch: Chandle; procEnum: NimProc; chArgsPtr: svOpenArrayHandle): cstring {.exportc, dynlib.} =
  callProc[cstring](ch, procEnum, chArgsPtr)
