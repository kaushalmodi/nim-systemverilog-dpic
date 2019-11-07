import std/[strutils, strformat]
import svdpi

template logInfo(data: string): untyped =
  let
    pos = instantiationInfo()
    lineInfo = "[INFO]($1:$2:) " % [pos.filename, $pos.line]
  echo lineInfo & fmt(data)

## byte
proc transform_char(inp: cschar): cschar =
  logInfo "transform_char in: {inp}"
  # The original C code uses an invalid 8-bit signed value: 255. So
  # replacing that with the actual 8-bit signed value: -1.
  return -1 - inp

proc compute_byte(i_value: cschar; resPtr: ptr cschar) {.exportc.} =
  logInfo "dpi_c.compute_byte(): received value {i_value}"
  resPtr[] = transform_char(i_value)
  logInfo "dpi_c.compute_byte(): return value {resPtr[]}"

proc get_byte(i_value: cschar): cschar {.exportc.} =
  logInfo "dpi_c.get_byte(): received {i_value}"
  result = transform_char(i_value);
  logInfo "dpi_c.get_byte(): return {result}"

## shortint
proc transform_short_int(inp: cshort): cshort =
  # The original C code uses an invalid 16-bit signed value: 65535. So
  # replacing that with the actual 16-bit signed value: -1.
  return -1 - inp

proc compute_shortint(i_value: cshort; resPtr: ptr cshort) {.exportc.} =
  logInfo "dpi_c.compute_shortint(): received {i_value}"
  resPtr[] = transform_short_int(i_value)
  logInfo "dpi_c.compute_shortint(): return {resPtr[]}"

proc get_shortint(i_value: cshort): cshort {.exportc.} =
  logInfo "dpi_c.get_shortint(): received {i_value}"
  result = transform_short_int(i_value)
  logInfo "dpi_c.get_shortint(): return {result}"

## int
proc transform_int(inp: cint): cint = 23*inp

proc compute_int(i_value: cint; resPtr: ptr cint) {.exportc.} =
  logInfo "dpi_c.compute_int(): received {i_value}"
  resPtr[] = transform_int(i_value)
  logInfo "dpi_c.compute_int(): return {resPtr[]}"

proc get_int(i_value: cint): cint {.exportc.} =
  logInfo "dpi_c.get_int(): received {i_value}"
  result = transform_int(i_value)
  logInfo "dpi_c.get_int(): return {result}"

## longint
# The original C code has some bug .. it prints:
#  test.test_longint calls compute_longint with   2809549300312324577
#  [INFO](libdpi.c:75:) dpi_c.compute_longint(): received -133154335   <-- incorrect received value
#  [INFO](libdpi.c:77:) dpi_c.compute_longint(): return 801885979
#  [INFO](libdpi.c:81:) dpi_c.get_longint(): received -133154335
#  [INFO](libdpi.c:83:) dpi_c.get_longint(): return 801885979
# Whereas Nim correctly prints:
#  int calls compute_longint with   2809549300312324577
#  [INFO](libdpi.nim:59:) dpi_c.compute_longint(): received 2809549300312324577
#  [INFO](libdpi.nim:61:) dpi_c.compute_longint(): return -4913573462065557733
#  [INFO](libdpi.nim:64:) dpi_c.get_longint(): received 2809549300312324577
#  [INFO](libdpi.nim:66:) dpi_c.get_longint(): return -4913573462065557733

proc transform_long_int(inp: clonglong): clonglong = 123*inp

proc compute_longint(i_value: clonglong; resPtr: ptr clonglong) {.exportc.} =
  logInfo "dpi_c.compute_longint(): received {i_value}"
  resPtr[] = transform_long_int(i_value)
  logInfo "dpi_c.compute_longint(): return {resPtr[]}"

proc get_longint(i_value: clonglong): clonglong {.exportc.} =
  logInfo "dpi_c.get_longint(): received {i_value}"
  result = transform_long_int(i_value)
  logInfo "dpi_c.get_longint(): return {result}"

## real
proc transform_double(inp: cdouble): cdouble = inp*3

proc compute_real(i_value: cdouble; resPtr: ptr cdouble) {.exportc.} =
  logInfo "dpi_c.compute_real(): received {i_value}"
  resPtr[] = transform_double(i_value)
  logInfo "dpi_c.compute_real(): return {resPtr[]}"

proc get_real(i_value: cdouble): cdouble {.exportc.} =
  logInfo "dpi_c.get_real(): received {i_value}"
  result = transform_double(i_value)
  logInfo "dpi_c.get_real(): return {result}"

## string
proc compute_string(i_value: cstring; resPtr: ptr cstring) {.exportc.} =
  logInfo "dpi_c.compute_string(): received {i_value}"
  resPtr[] = "DEAF_BEAF_DRINKS_COFFEE"
  logInfo "dpi_c.compute_string(): return {resPtr[]}"

proc get_string(i_value: cstring): cstring {.exportc.} =
  logInfo "dpi_c.get_string(): received {i_value}"
  result = "DEAF_BEAF_DRINKS_COFFEE"
  logInfo "dpi_c.get_string(): return {result}"

## string array
proc compute_string_array(i_value: svOpenArrayHandle; resHandle: svOpenArrayHandle) {.exportc.} =
  let
    iValPtr = cast[ptr UncheckedArray[cstring]](svGetArrayPtr(i_value))
    oValPtr = cast[ptr UncheckedArray[cstring]](svGetArrayPtr(resHandle))
  logInfo "dpi_c.compute_string_array(): inputs {{{iValPtr[][0]}, {iValPtr[][1]}, {iValPtr[][2]}}}"
  for idx, val in ["DEAF_BEAF", "DRINKS", "COFFEE"]:
    oValPtr[][idx] = val
  logInfo "dpi_c.compute_string_array(): return value {{{oValPtr[][0]}, {oValPtr[][1]}, {oValPtr[][2]}}}"

## bit
proc transform_svBit(inp: svBit): svBit =
  # echo fmt"inp = {inp}"
  # echo fmt"not inp = {not inp}"
  result = (not inp) and svBit(1)
  # echo fmt"(not inp) && 8'b0000_0001 = {result}"

proc compute_bit(i_value: svBit; resPtr: ptr svBit) {.exportc.} =
  logInfo "dpi_c.compute_bit(): input {i_value}"
  resPtr[] = transform_svBit(i_value)
  logInfo "dpi_c.compute_bit(): result {resPtr[]}"

proc get_bit(i_value: svBit): svBit {.exportc.} =
  logInfo "dpi_c.get_bit(): input {i_value}"
  result = transform_svBit(i_value)
  logInfo "dpi_c.get_bit(): result {result}"

## bit vector
proc transform_svBitVecVal(inp: svBitVecVal): svBitVecVal = (inp shl 3) + 2

proc compute_bit_vector(iValuePtr: ptr svBitVecVal; resPtr: ptr svBitVecVal) {.exportc.} =
  logInfo "dpi_c.compute_bit_vector(): input {iValuePtr[]} ({iValuePtr[]:#b})"
  resPtr[] = transform_svBitVecVal(iValuePtr[])
  logInfo "dpi_c.compute_bit_vector(): result {resPtr[]} ({resPtr[]:#b})"

proc get_bit_vector(iValuePtr: ptr svBitVecVal): svBitVecVal {.exportc.} =
  logInfo "dpi_c.get_bit_vector(): input {iValuePtr[]} ({iValuePtr[]:#b})"
  result = transform_svBitVecVal(iValuePtr[])
  logInfo "dpi_c.get_bit_vector(): result {result} ({result:#b})"

## logic
type
  SvLogic = enum
    sv_0 = "0"
    sv_1 = "1"
    sv_z = "Z"
    sv_x = "X"

proc transform_svLogic(inp: svLogic): svLogic =
  return svLogic(case SvLogic(inp)
                 of sv_0:
                   sv_1
                 of sv_1:
                   sv_x
                 of sv_z:
                   sv_0
                 of sv_x:
                   sv_z)

proc compute_logic(i_value: svLogic; resPtr: ptr svLogic) {.exportc.} =
  logInfo "dpi_c.compute_logic(): integer value:{i_value}, input {SvLogic(i_value)}"
  resPtr[] = transform_svLogic(i_value)
  logInfo "dpi_c.compute_logic(): result {SvLogic(resPtr[])} <- {SvLogic(i_value)}"

proc get_logic(i_value: svLogic): svLogic {.exportc.} =
  logInfo "dpi_c.get_logic(): input {SvLogic(i_value)}"
  result = transform_svLogic(i_value)
  logInfo "dpi_c.get_logic(): result {SvLogic(result)} <- {SvLogic(i_value)}"

## logic vector
proc svLogicVecVal2String(svlvvPtr: ptr svLogicVecVal; asize: cint): string =
  ## Convert svLogicVecVal (e.g. logic[4:0]) to string.
  result = "'b"
  for i in countDown(asize-1, 0):
    result.add($SvLogic(svGetBitselLogic(svlvvPtr, i)))

proc compute_logic_vector(iValuePtr: ptr svLogicVecVal; resPtr: ptr svLogicVecVal; asize: cint) {.exportc.} =
  logInfo "dpi_c.compute_logic_vector(): input {svLogicVecVal2String(iValuePtr, asize)}"
  for i in 0 ..< asize:
    let
      bit = transform_svLogic(svGetBitselLogic(iValuePtr, i))
    svPutBitselLogic(resPtr, i, bit)
  logInfo "dpi_c.compute_logic_vector(): result {svLogicVecVal2String(resPtr, asize)}"

proc get_logic_vector(iValuePtr: ptr svLogicVecVal; asize: cint): ptr svLogicVecVal {.exportc.} =
  logInfo "dpi_c.get_logic_vector(): input {svLogicVecVal2String(iValuePtr, asize)}"
  for i in 0 ..< asize:
    let
      bit = transform_svLogic(svGetBitselLogic(iValuePtr, i))
    svPutBitselLogic(result, i, bit)
  logInfo "dpi_c.get_logic_vector(): result {svLogicVecVal2String(result, asize)}"

## reg
proc compute_reg(i_value: svLogic; resPtr: ptr svLogic) {.exportc.} =
  logInfo "dpi_c.compute_reg(): integer value:{i_value}, input {SvLogic(i_value)}"
  resPtr[] = transform_svLogic(i_value)
  logInfo "dpi_c.compute_reg(): result {SvLogic(resPtr[])} <- {SvLogic(i_value)}"

proc get_reg(i_value: svLogic): svLogic {.exportc.} =
  logInfo "dpi_c.get_reg(): input {SvLogic(i_value)}"
  result = transform_svLogic(i_value)
  logInfo "dpi_c.get_reg(): result {SvLogic(result)} <- {SvLogic(i_value)}"

## reg vector
proc compute_reg_vector(iValuePtr: ptr svLogicVecVal; resPtr: ptr svLogicVecVal; asize: cint) {.exportc.} =
  logInfo "dpi_c.compute_reg_vector(): input {svLogicVecVal2String(iValuePtr, asize)}"
  for i in 0 ..< asize:
    let
      bit = transform_svLogic(svGetBitselLogic(iValuePtr, i))
    svPutBitselLogic(resPtr, i, bit)
  logInfo "dpi_c.compute_reg_vector(): result {svLogicVecVal2String(resPtr, asize)}"

proc get_reg_vector(iValuePtr: ptr svLogicVecVal; asize: cint): ptr svLogicVecVal {.exportc.} =
  logInfo "dpi_c.get_reg_vector(): input {svLogicVecVal2String(iValuePtr, asize)}"
  for i in 0 ..< asize:
    let
      bit = transform_svLogic(svGetBitselLogic(iValuePtr, i))
    svPutBitselLogic(result, i, bit)
  logInfo "dpi_c.get_reg_vector(): result {svLogicVecVal2String(result, asize)}"

## chandle
proc print_chandle(): cint =
  logInfo "dpi_c.print_chandle()"
  return 10

type
  Chandle = pointer # Alias Nim type "pointer" to "Chandle" just for better readability

# import "DPI-C" function void compute_chandle(output chandle result);
proc compute_chandle(chandlePtr: ptr Chandle) {.exportc.} =
  chandlePtr[] = cast[Chandle](print_chandle)
  logInfo "dpi_c.compute_chandle() {repr(chandlePtr)}"

# import "DPI-C" function chandle get_chandle();
proc get_chandle(): Chandle {.exportc.} =
  result = cast[Chandle](print_chandle)
  logInfo "dpi_c.get_chandle() {repr(result)}"

# import "DPI-C" function void call_chandle(input chandle i_value, output int result);
proc call_chandle(inChandle: Chandle; oValuePtr: ptr cint) {.exportc.} =
  logInfo "dpi_c.call_chandle() {repr(inChandle)}"
  let
    pcp = cast[proc(): cint {.cdecl.}](inChandle) # {.cdecl.} enforces "C function type" vs "Nim proc type"
    # pcp = cast[type print_chandle](inChandle) # this works too
  oValuePtr[] = pcp()
  logInfo "dpi_c.call_chandle() returns {oValuePtr[]}"

proc compute_unsized_T_array[T: SomeInteger](inDArrHandle, outDArrHandle: svOpenArrayHandle) =
  let
    arrLen = svSize(inDArrHandle, 1)
    arrSize = svSizeOfArray(inDArrHandle)
  # Method 1: First copy inp array to outp array, and then increment
  #           all elements in outp array by 3.
  copyMem(cast[ptr T](svGetArrayPtr(outDArrHandle)),
          cast[ptr T](svGetArrayPtr(inDArrHandle)),
          arrSize)
  for i in 0 ..< arrLen:
    let
      outTArrElemPtr = cast[ptr T](svGetArrElemPtr1(outDArrHandle, i))
    outTArrElemPtr[] += 3
  # # Method 2: Loop through all inp array elements, and set outp array
  # #           elem = inp array elem + 3
  # for i in 0 ..< arrLen:
  #   let
  #     inTArrElemPtr = cast[ptr cint](svGetArrElemPtr1(inDArrHandle, i))
  #     outTArrElemPtr = cast[ptr cint](svGetArrElemPtr1(outDArrHandle, i))
  #   outTArrElemPtr[] = inTArrElemPtr[] + 3

## unsized int array
proc compute_unsized_int_array(inDArrHandle, outDArrHandle: svOpenArrayHandle) {.exportc.} =
  compute_unsized_T_array[cint](inDArrHandle, outDArrHandle)

## unsized byte array
proc compute_unsized_byte_array(inDArrHandle, outDArrHandle: svOpenArrayHandle) {.exportc.} =
  compute_unsized_T_array[cschar](inDArrHandle, outDArrHandle)

## struct
type
  MyStruct = object
    aChar: cschar
    anInt: cint
    aBit: svBit
    aLongInt: clonglong
    aBitVector: svBitVecVal

proc transform_struct(inpPtr: ptr MyStruct): MyStruct =
  logInfo "dpi_c: input struct = {inpPtr[]}"

  copyMem(addr result, inpPtr, sizeof(MyStruct))
  result.aBit = transform_svBit(result.aBit)
  result.aChar = transform_char(result.aChar)
  result.anInt = transform_int(result.anInt)
  result.aLongInt = transform_long_int(result.aLongInt)
  result.aBitVector = transform_svBitVecVal(result.aBitVector)
  logInfo "dpi_c: output struct = {result}"

proc compute_struct(iValuePtr, oValuePtr: ptr MyStruct) {.exportc.} =
  oValuePtr[] = transform_struct(iValuePtr)
