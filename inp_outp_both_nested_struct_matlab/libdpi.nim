# import svdpi
import mean_func_3, strformat

const
  Max = 20 # this needs to match the MAX parameter in tb.sv
type
  InpStructElem = object # this needs to match the workaround struct in_struct_wrapper_s in tb.sv
    arr: array[Max, cint]
    length: cint
  InpStructWrapper = object # this needs to match the workaround struct in_struct_s in tb.sv
    a, b, c: InpStructElem

proc get_mean_func_3_out(inStruct: InpStructWrapper): OutputObj =
  let
    inputObjPtr = cast[ptr InputObj](alloc0(sizeof InputObj))
    outputObjPtr = cast[ptr OutputObj](alloc0(sizeof OutputObj))

  # echo fmt"input [debug in Nim] = {inStruct.a.arr}"

  for key, sElem in inStruct.fieldPairs:
    # echo "struct element [debug in Nim]: ", key, " = ", sElem
    let
      inputArrPtr = cast[ptr UncheckedArray[cint]](unsafeAddr sElem.arr[0])
      inputSizeArray = [sElem.length]
      inputSizeArrayPtr = cast[ptr UncheckedArray[cint]](unsafeAddr inputSizeArray[0])
      intArrayObjPtr = cast[ptr IntArrayObj](alloc0(sizeof IntArrayObj))
      arrWrapObjPtr = cast[ptr ArrWrapObj](alloc0(sizeof ArrWrapObj))

    # for i in 0 ..< sElem.length:
    #   echo $inputArrPtr[][i]

    intArrayObjPtr[].data = inputArrPtr
    intArrayObjPtr[].size = inputSizeArrayPtr

    arrWrapObjPtr[].data = intArrayObjPtr
    arrWrapObjPtr[].len = sElem.length.cint

    case key
    of "a":
      inputObjPtr[].x1 = arrWrapObjPtr[]
    of "b":
      inputObjPtr[].x2 = arrWrapObjPtr[]
    of "c":
      inputObjPtr[].x3 = arrWrapObjPtr[]
    else:
      discard

  mean_func(inputObjPtr, outputObjPtr)
  return outputObjPtr[]

proc get_params(inStruct: ptr InpStructWrapper; outStruct: ptr OutputObj) {.exportc, dynlib.} =
  # echo $inStruct[]
  outStruct[] = get_mean_func_3_out(inStruct[])
