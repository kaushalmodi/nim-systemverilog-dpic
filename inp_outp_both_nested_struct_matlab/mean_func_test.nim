import mean_func_3

let
  inputData = [ @[632.cint, 68, 87, 73, 22, 63, 20],
                @[104.cint, 36, 53, 35, 00, 36, 51, 73],
                @[080.cint, 83, 60, 66, 77, 50, 40, 64, 07, 24] ]
  inputObjPtr = cast[ptr InputObj](alloc0(sizeof InputObj))
  outputObjPtr = cast[ptr OutputObj](alloc0(sizeof OutputObj))

for idx, s in inputData:
  let
    length = s.len
    inputSeqPtr = cast[ptr UncheckedArray[cint]](unsafeAddr s[0])
    inputSizeArray = [length]
    inputSizeArrayPtr = cast[ptr UncheckedArray[cint]](unsafeAddr inputSizeArray[0])
    intArrayObjPtr = cast[ptr IntArrayObj](alloc0(sizeof IntArrayObj))
    arrWrapObjPtr = cast[ptr ArrWrapObj](alloc0(sizeof ArrWrapObj))

  # for i in 0 ..< s.len:
  #   echo $inputSeqPtr[][i]

  intArrayObjPtr[].data = inputSeqPtr
  intArrayObjPtr[].size = inputSizeArrayPtr

  arrWrapObjPtr[].data = intArrayObjPtr
  arrWrapObjPtr[].len = length.cint

  # echo "len = ", arrWrapObjPtr[].len

  case idx:
  of 0:
    inputObjPtr[].x1 = arrWrapObjPtr[]
  of 1:
    inputObjPtr[].x2 = arrWrapObjPtr[]
  of 2:
    inputObjPtr[].x3 = arrWrapObjPtr[]

# echo $inputObjPtr[]
# for i in 0 ..< inputObjPtr[].x1.len:
#   echo $inputObjPtr[].x1.data[].data[][i] #works

mean_func(inputObjPtr, outputObjPtr)

echo inputData
echo $outputObjPtr[]
