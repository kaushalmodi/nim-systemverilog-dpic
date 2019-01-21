import svdpi
import strformat

# Open array example
proc pass_int_array(dyn_arr: svOpenArrayHandle) {.exportc.} =
  echo fmt"  Array: Left index = {svLeft(dyn_arr, 1)}, Right index = {svRight(dyn_arr, 1)}"
  # Note that using svLeft / svRight doesn't always work as expected
  # because the arrays could be declared as "int fxd_arr_1 [3:8];" or
  # "int fxd_arr_1 [8:3];". But svLow / svHigh will always work as
  # expected.
  echo fmt"  Array: High index = {svHigh(dyn_arr, 1)}, Low index = {svLow(dyn_arr, 1)}"
  echo ""
  let
    lowerIndex = svLow(dyn_arr, 1)
    upperIndex = svHigh(dyn_arr, 1)
  for i in lowerIndex .. upperIndex:
    let
      # The SV arrays are declared to be of int type:
      #   int fxd_arr_1 [3:8];
      #   int fxd_arr_2 [12:1];
      # So cast the pointer to int32 or cint pointer.
      valPtr = cast[ptr int32](svGetArrElemPtr1(dyn_arr, i))
      val = valPtr[]
    echo fmt"  Nim: array[{i:>2}]: {val:>11}"
  echo "\n"

# Packed vectors example
# The packed vectors are always passed by reference from the SV side.
# http://geekwentfreak.com/posts/eda/SystemVerilog_C_pass_datatypes/
proc add_lpv(aRef, bRef, cRef: ref svLogicVecVal) {.exportc.} =
  let
    a = aRef[].aval
    b = bRef[].aval
  echo fmt"a = {aRef[]}"
  echo fmt"b = {bRef[]}"
  cRef[].aval = a + b
  cRef[].bval = 0   # Assume that neither a nor b are X or Z.
  echo fmt"c = {cRef[]}"
