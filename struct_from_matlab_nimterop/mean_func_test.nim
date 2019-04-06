import mean_func_1

let
  inputData = [100.cint, 3, 7, 5]
  inputDataPtr = cast[ptr UncheckedArray[cint]](unsafeAddr inputData[0])
  dataObjPtr = cast[ptr DataObj](alloc0(sizeof DataObj))

dataObjPtr[].data = inputDataPtr

let
  inp1 = InputObjRef(data: dataObjPtr,
                     len: inputData.len.cint)
  out1: OutputObjRef = new(OutputObj) # initialize

mean_func_1(inp1, out1)

echo inputData
echo $out1[]
