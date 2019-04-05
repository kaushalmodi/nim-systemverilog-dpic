import mean_func_1

let
  inputData = [100.cint, 3, 7, 5]
  dataPtr = cast[ptr UncheckedArray[cint]](unsafeAddr inputData[0])

  dataObjRef = DataObjRef(data: dataPtr)

  inp1 = InputObjRef(data: dataObjRef,
                     len: inputData.len.cint)
  out1: OutputObjRef = new(OutputObj) # initialize

mean_func_1(inp1, out1)

echo inputData
echo $out1[]
