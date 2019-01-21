import svdpi
import strformat

type
  nimObj = object
    a: int32 # int in SV
    b: int32 # int in SV
    c: int8  # byte in SV

proc export_func(x: array[3, svBitVec32]) {.importc.}

proc import_func() {.exportc.} =
  ## Converts data from ``nimObj`` to an array.
  ## ``export_func`` is called which converts that array to struct.
  let
    data = nimObj(a: 51,
                  b: 242,
                  c: 35)
    arr: array[3, svBitVec32] = [svBitVec32(data.a), svBitVec32(data.b), svBitVec32(data.c)]
  echo fmt"Nim: data = {data}"
  echo fmt"Nim: arr = {arr}"
  export_func(arr)
