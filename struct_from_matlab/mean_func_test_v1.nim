type
  Boolean* = cuchar

  DataObj* = object
    data: ptr UncheckedArray[cint]
    size: ptr UncheckedArray[cint]
    allocatedSize: cint
    numDimensions: cint
    canFreeData: Boolean
  DataObjRef* = ref DataObj

  # struct0_T
  InputObj* = object
    data: DataObjRef
    Len: cint # length of data.data[]
  InputObjRef* = ref InputObj

  # struct1_T
  OutputObj* = object
    mean: cdouble
    Max: cint
    Min: cint
  OutputObjRef* = ref OutputObj

proc mean_func_1(inp: InputObjRef; outp: OutputObjRef) {.cdecl, dynlib: "mean_func_1.so", importc.}

# not needed
# let
#   sizeLen = 1

# var
#   sizePtr0 = alloc0(sizeof(cint) * sizeLen)
#   sizePtr1 = cast[ptr UncheckedArray[cint]](sizePtr0)

let
  inputData = [1.cint, 3, 5, 7]
  dataLen = inputData.len

var
  dataSize = sizeof(cint) * dataLen
  dataPtr0 = alloc0(dataSize)
  dataPtr1 = cast[ptr UncheckedArray[cint]](dataPtr0)

  dataObjRef = DataObjRef(data: dataPtr1)

  inp1 = InputObjRef(data: dataObjRef)
  out1: OutputObjRef = new(OutputObj)

# inp1[].data[].data[] = [1.cint, 3, 5, 7].UncheckedArray[cint] # doesn't work
for idx, val in inputData:
  inp1[].data[].data[idx] = val
  inp1[].Len += 1.cint

mean_func_1(inp1, out1)

echo out1[].mean
echo out1[].Max
echo out1[].Min
