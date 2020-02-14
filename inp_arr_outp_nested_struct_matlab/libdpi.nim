import svdpi, mean_func_2, strformat

type
  InpStructWrapper = object # this is needed to match the workaround struct in_struct_wrapper_s created in tb.sv
    arr: array[3, array[10, cint]]

proc get_mean_func_2_out(inStruct: InpStructWrapper): OutputObj =
  let
    out1: OutputObjRef = new(OutputObj) # initialize
  var
    inp1: array[3, InputObj]

  echo fmt"input [debug in Nim] = {inStruct.arr}"
  for idx, arr in inStruct.arr:
    inp1[idx] = InputObj(data: arr, len: arr.len.cint)

  mean_func(inp1, out1)
  return out1[]

proc get_params(inStruct: ref InpStructWrapper; outStruct: ref OutputObj) {.exportc, dynlib.} =
  outStruct[] = get_mean_func_2_out(inStruct[])
