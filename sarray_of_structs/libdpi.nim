const
  Max = 3

type
  Bit = range[0.byte .. 1.byte]
  SomeStr = object
    scalarBit: Bit
    scalarReal: cdouble
    scalarInt: cint
    arrInt: array[Max, cint]
  SomeStrArr = array[Max, SomeStr]

proc printStruct(objPtr: ptr SomeStrArr) {.exportc, dynlib.} =
  echo "Printing from Nim:"
  echo objPtr[]
