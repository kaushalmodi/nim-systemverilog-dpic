import os, svdpi, mean_func_1

proc get_mean_func_1_out(arrPtr: svOpenArrayHandle): OutputObj =
  let
    arrSize = svSizeOfArray(arrPtr)
    arrLen = svLength(arrPtr, 1)
    uncheckedArrPtr = cast[ptr UncheckedArray[cint]](alloc0(arrSize))
    dataObjPtr = cast[ptr DataObj](alloc0(sizeof(DataObj)))
    inputObjPtr = cast[ptr InputObj](alloc0(sizeof(InputObj)))
    outputObjPtr = cast[ptr OutputObj](alloc0(sizeof(OutputObj)))

  dataObjPtr[].data = uncheckedArrPtr

  inputObjPtr[].data = dataObjPtr
  inputObjPtr[].len = arrLen

  for i in 0.cint ..< arrLen:
    let
      arrElemPtr = cast[ptr cint](svGetArrElemPtr1(arrPtr, i))
    inputObjPtr[].data[].data[i] = arrElemPtr[]

  mean_func(inputObjPtr, outputObjPtr)
  return outputObjPtr[]

proc get_mean(arrPtr: svOpenArrayHandle): cdouble {.exportc, dynlib.} =
  return get_mean_func_1_out(arrPtr).mean

proc get_max(arrPtr: svOpenArrayHandle): cint {.exportc, dynlib.} =
  return get_mean_func_1_out(arrPtr).max

proc get_min(arrPtr: svOpenArrayHandle): cint {.exportc, dynlib.} =
  return get_mean_func_1_out(arrPtr).min

proc get_params(arrPtr: svOpenArrayHandle; params: ptr OutputObj) {.exportc, dynlib.} =
  params[] = get_mean_func_1_out(arrPtr)
