import svdpi
import strformat

type
  nimObj = object
    p: cint  # int in SV
    q: cint  # int in SV
    r: uint8 # byte in SV

proc export_func(x: array[3, svBitVec32]) {.importc.}

proc import_func() {.exportc.} =
  ## Converts data from ``nimObj`` to an array.
  ## ``export_func`` is called which converts that array to struct.
  let
    data = nimObj(p: 51,
                  q: 242,
                  r: 35)
    arr: array[3, svBitVec32] = [svBitVec32(data.p), svBitVec32(data.q), svBitVec32(data.r)]
  echo fmt"Nim: data = {data}"
  echo fmt"Nim: arr = {arr}"
  export_func(arr)

proc send_arr_struct_pkd(dyn_arr: svOpenArrayHandle) {.exportc.} =
  let
    lowerIndex1 = svLow(dyn_arr, 1)
    upperIndex1 = svHigh(dyn_arr, 1)
  echo fmt"  lower index = {lowerIndex1}, upper index = {upperIndex1}"
  for i in lowerIndex1 .. upperIndex1:
    let
      elemPtr = cast[ptr nimObj](svGetArrElemPtr1(dyn_arr, i))
      nimObjElem = elemPtr[]
    echo fmt"  Nim: Element at index {i} = {nimObjElem}"
  echo ""

# Mon Jan 21 15:48:18 EST 2019 - kmodi
# On the SV side, I cannot do:
#  import "DPI-C" send_arr_struct_pkd = function void send_arr_struct_pkd (input PkdStruct arr []);
#  import "DPI-C" send_arr_struct_pkd = function void send_arr_struct_unpkd (input UnPkdStruct arr []);
# and map the SV function "send_arr_struct_unpkd" to the same "send_arr_struct_pkd" proc above.
#
# But the below will work instead. Interesting ..
proc send_arr_struct_unpkd(dyn_arr: svOpenArrayHandle) {.exportc.} =
  echo "** Unpacked struct **"
  send_arr_struct_pkd(dyn_arr)

proc send_union(fa, fu: ref svBitVecVal) {.exportc.} =
  echo fmt"  Nim: fa = {fa[]:x}, fu = {fu[]:x}"
