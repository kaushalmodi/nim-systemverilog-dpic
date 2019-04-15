import svdpi
import strformat

# Open array example
proc pass_int_array(dyn_arr: svOpenArrayHandle) {.exportc.} =
  echo fmt" Array:"
  echo fmt"  Dimensions = {svDimensions(dyn_arr)}"
  echo fmt"  Size in bytes = {svSizeOfArray(dyn_arr)}"
  echo fmt"  Pointer = {cast[int](svGetArrayPtr(dyn_arr)):#x}"
  echo fmt"  Length = {svLength(dyn_arr, 1)}"
  echo fmt"  Left index = {svLeft(dyn_arr, 1)}, Right index = {svRight(dyn_arr, 1)}, Incremental step = {svIncrement(dyn_arr, 1)}"
  # Note that using svLeft / svRight doesn't always work as expected
  # because the arrays could be declared as "int fxd_arr_1 [3:8];" or
  # "int fxd_arr_1 [8:3];". But svLow / svHigh will always work as
  # expected.
  # Based on the seen output, this is what svIncrement returns:
  #   - Return 1 if svLeft > svHigh
  #   - Return 1 if svLeft == svHigh
  #   - Return 0 if svLeft < svHigh
  echo fmt"  High index = {svHigh(dyn_arr, 1)}, Low index = {svLow(dyn_arr, 1)}"
  echo fmt"  "
  echo ""
  let
    lowerIndex1 = svLow(dyn_arr, 1)
    upperIndex1 = svHigh(dyn_arr, 1)
  for i in lowerIndex1 .. upperIndex1:
    let
      # The SV arrays are declared to be of int type:
      #   int fxd_arr_1 [3:8];
      #   int fxd_arr_2 [12:1];
      # So cast the pointer to cint or int32 pointer.
      valPtr = cast[ptr cint](svGetArrElemPtr1(dyn_arr, i))
      val = valPtr[]
    echo fmt"  Nim: array[{i:>2}]: {val:>11}"
  echo "\n"

# Packed vectors example
# The packed vectors are always passed by reference from the SV side.
# http://geekwentfreak.com/posts/eda/SystemVerilog_C_pass_datatypes/
proc add_lpv(aPtr, bPtr, cPtr: ptr svLogicVecVal) {.exportc.} =
  let
    a = aPtr[].aval
    b = bPtr[].aval
  echo fmt"a = {aPtr[]}"
  echo fmt"b = {bPtr[]}"
  cPtr[].aval = a + b
  cPtr[].bval = 0   # Assume that neither a nor b are X or Z.
  echo fmt"c = {cPtr[]}"

# Packed logic array example
# An array of packed logic is passed as a reference to an array of
# svLogicVecVal from the SV side. But as per Araq, using "var array"
# is the correct approach, and not "ref array".
# - https://irclogs.nim-lang.org/21-01-2019.html#18:20:35
proc get_nums_var_arg(nums: var array[10, svLogicVecVal]) {.exportc.} =
  echo fmt"packed logic array length = {nums.len}"
  for i in 0 .. nums.high:
    nums[i].aval = uint32(i+10)
    nums[i].bval = 0
    # The echoing of the array elements causes crash if nim
    # compilation is done without --gc:none *or* --gc:regions.
    echo fmt"Nim: nums[{i}] = {nums[i]}"

# Even though not recommended, the "ref array" approach works:
proc get_nums_ref_arg1(numsRef: ref array[10, svLogicVecVal]) {.exportc.} =
  echo fmt"packed logic array length = {numsRef[].len}"
  for i in 0 .. numsRef[].high:
    numsRef[][i].aval = uint32(i+10)
    numsRef[][i].bval = 0
    echo fmt"Nim: get_nums_ref_arg1: numsRef[][{i}] = {numsRef[][i]}"

# Above can be alternatively written as below too; again: not
# recommended.
proc get_nums_ref_arg2(numsRef: ref array[10, svLogicVecVal]) {.exportc.} =
  var
    nums = numsRef[]
  echo fmt"packed logic array length = {nums.len}"
  for i in 0 .. nums.high:
    nums[i].aval = uint32(i+10)
    nums[i].bval = 0
    echo fmt"Nim: get_nums_ref_arg2: nums[{i}] = {nums[i]}"
  numsRef[] = nums
