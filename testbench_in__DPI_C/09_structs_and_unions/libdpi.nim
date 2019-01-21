import svdpi
import strformat

type
  nimObj = object
    a: int32 # int in SV
    b: int32 # int in SV
    c: int8  # byte in SV
  nimObj2 = object
    p: int32
    q: int32
    # r: int8
    r: int32

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

# Mon Jan 21 15:24:16 EST 2019 - kmodi
# FIXME: Cadence Xcelium
# The order of elements in reversed in the packaged struct sent via
# DPI-C.
proc send_arr_packed_struct(dyn_arr: svOpenArrayHandle) {.exportc.} =
  let
    lowerIndex1 = svLow(dyn_arr, 1)
    upperIndex1 = svHigh(dyn_arr, 1)
  echo fmt"  lower index = {lowerIndex1}, upper index = {upperIndex1}"
  for i in lowerIndex1 .. upperIndex1:
    let
      elemPtr = cast[ptr nimObj2](svGetArrElemPtr1(dyn_arr, i))
      nimObj2Elem = elemPtr[]
    echo fmt"  Nim: Packed struct element at index {i} = {nimObj2Elem}"
