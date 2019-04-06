import svdpi, mean_func_1

proc get_mean_func_1_out(arrPtr: svOpenArrayHandle): OutputObj =
  let
    arrSize = svSizeOfArray(arrPtr)
    arrLen = svLength(arrPtr, 1)
    uncheckedArrPtr = cast[ptr UncheckedArray[cint]](alloc0(arrSize))
    dataObjPtr = cast[ptr DataObj](alloc0(sizeof DataObj))

  dataObjPtr[].data = uncheckedArrPtr

  let
    inp1 = InputObjRef(data: dataObjPtr,
                       len: arrLen)
    out1: OutputObjRef = new(OutputObj) # initialize

  for i in 0.cint ..< arrLen:
    let
      arrElemPtr = cast[ptr cint](svGetArrElemPtr1(arrPtr, i))
    inp1[].data[].data[i] = arrElemPtr[]

  mean_func_1(inp1, out1)
  return out1[]

proc get_mean(arrPtr: svOpenArrayHandle): cdouble {.exportc.} =
  return get_mean_func_1_out(arrPtr).mean

proc get_max(arrPtr: svOpenArrayHandle): cint {.exportc.} =
  return get_mean_func_1_out(arrPtr).max

proc get_min(arrPtr: svOpenArrayHandle): cint {.exportc.} =
  return get_mean_func_1_out(arrPtr).min

proc get_params(arrPtr: svOpenArrayHandle; params: OutputObjRef) {.exportc.} =
  params[] = get_mean_func_1_out(arrPtr)
