import svdpi, mean_func_1

proc get_mean_func_1_out(arrPtr: svOpenArrayHandle): OutputObj =
  let
    arrSize = svSizeOfArray(arrPtr)
    arrLen = svLength(arrPtr, 1)
    uncheckedArrPtr0 = alloc0(arrSize)
    uncheckedArrPtr1 = cast[ptr UncheckedArray[cint]](uncheckedArrPtr0)
    dataObjRef = DataObjRef(data: uncheckedArrPtr1)
    inp1 = InputObjRef(data: dataObjRef,
                       Len: arrLen)
    out1: OutputObjRef = new(OutputObj) # initialize

  for i in 0.cint ..< arrLen:
    let
      arrElemPtr = cast[ptr cint](svGetArrElemPtr1(arrPtr, i))
    inp1[].data[].data[i] = arrElemPtr[]

  mean_func_1(inp1, out1)
  return out1[]

proc get_mean(arrPtr: svOpenArrayHandle): cdouble {.exportc, dynlib.} =
  return get_mean_func_1_out(arrPtr).mean

proc get_max(arrPtr: svOpenArrayHandle): cint {.exportc, dynlib.} =
  return get_mean_func_1_out(arrPtr).Max

proc get_min(arrPtr: svOpenArrayHandle): cint {.exportc, dynlib.} =
  return get_mean_func_1_out(arrPtr).Min

proc get_params(arrPtr: svOpenArrayHandle; params: ref OutputObj) {.exportc, dynlib.} =
  params[] = get_mean_func_1_out(arrPtr)
