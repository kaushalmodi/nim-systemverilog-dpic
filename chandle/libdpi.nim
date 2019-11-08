import svdpi

type
  # Alias Nim type "pointer" to "Chandle" just for better readability.
  Chandle = pointer

proc adder(args: openArray[cint]): cint =
  for arg in args:
    result = result + arg

proc getAdderProcHandle(): Chandle {.exportc.} =
  ## Return pointer to a "C function type".
  result = cast[Chandle](adder)

proc callAdderProc(ch: Chandle; chArgsPtr: svOpenArrayHandle): cint {.exportc.} =
  ## Call the C function pointed by ``ch`` with args referenced by ``chArgsPtr``.
  let
    procInst = cast[type adder](ch)
    args = svSVDynArr1ToSeq[cint](chArgsPtr)
  return procInst(args)
