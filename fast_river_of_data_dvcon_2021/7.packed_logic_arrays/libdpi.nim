import std/[strformat, strutils]
import svdpi

const
  width = 8

proc f_logicvector_sv(iPtr, oPtr, ioPtr: ptr svLogicVecVal): cint {.importc.}

proc logicVecValToStr[N: static int](lv: svLogicVecVal): string =
  result = newString(N)
  var
    aVal = lv.aval
    bVal = lv.bval
  # echo &"aVal = {aVal.int.toBin(N)}, bVal = {bVal.int.toBin(N)}"
  for i in 0 ..< N:
    let
      aBit = aVal and 1
      bBit = bVal and 1
    # echo &"  i = {i}, aBit = {aBit}, bBit = {bBit}"
    case ((aBit*10) + bBit)
    of 00: result[N-1-i] = '0'
    of 10: result[N-1-i] = '1'
    of 01: result[N-1-i] = 'z'
    else: result[N-1-i] = 'x'
    aVal = aVal shr 1
    bVal = bVal shr 1

proc f_logicvector_nim(iPtr, oPtr, ioPtr: ptr svLogicVecVal): cint {.exportc, dynlib.} =
  echo &"f_logicvector_nim: aval i={iPtr[].aval.int.toBin(width)}, o={oPtr[].aval.int.toBin(width)}, io={ioPtr[].aval.int.toBin(width)}"
  echo &"f_logicvector_nim: bval i={iPtr[].bval.int.toBin(width)}, o={oPtr[].bval.int.toBin(width)}, io={ioPtr[].bval.int.toBin(width)}"
  echo &"f_logicvector_nim: i={logicVecValToStr[width](iPtr[])}, o={logicVecValToStr[width](oPtr[])}, io={logicVecValToStr[width](ioPtr[])}"
  oPtr[].aval = iPtr[].aval
  oPtr[].bval = 255
  ioPtr[].aval = oPtr[].aval
  ioPtr[].bval = 255
  discard f_logicvector_sv(iPtr, oPtr, ioPtr)
  return 1
