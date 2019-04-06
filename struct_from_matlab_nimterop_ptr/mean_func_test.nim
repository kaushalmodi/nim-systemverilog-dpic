import mean_func_1

let
  inputData = [100.cint, 3, 7, 5]
  inputDataPtr = cast[ptr UncheckedArray[cint]](unsafeAddr inputData[0])
  dataObjPtr = cast[ptr DataObj](alloc0(sizeof DataObj))
  inputObjPtr = cast[ptr InputObj](alloc0(sizeof InputObj))
  outputObjPtr = cast[ptr OutputObj](alloc0(sizeof OutputObj))

dataObjPtr[].data = inputDataPtr

inputObjPtr[].data = dataObjPtr
inputObjPtr[].len = inputData.len.cint

mean_func(inputObjPtr, outputObjPtr)

echo inputData
echo $outputObjPtr[]
