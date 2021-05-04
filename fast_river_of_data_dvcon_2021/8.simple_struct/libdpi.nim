import std/[strformat]
import svdpi

type
  MyStruct = object
    b: svBit
    l: svLogic
    i: cint
    li: clonglong

proc f_my_struct_sv(iPtr, oPtr, ioPtr: ptr MyStruct): uint8 {.importc.} # To map to the 'bit' return type of f_my_struct_sv in SV

proc f_my_struct_nim(iPtr, oPtr, ioPtr: ptr MyStruct): cint {.exportc, dynlib.} =
  oPtr[].b = 1;
  oPtr[].l = 1;
  oPtr[].i = oPtr[].i + iPtr[].i + 1
  oPtr[].li = oPtr[].li + iPtr[].li + 1
  ioPtr[].b = 1;
  ioPtr[].l = 1;
  ioPtr[].i = ioPtr[].i + oPtr[].i + 1
  ioPtr[].li = ioPtr[].li + oPtr[].li + 1
  echo &"f_my_struct_nim (before): i={iPtr[]}, o={oPtr[]}, io={ioPtr[]}"
  result = f_my_struct_sv(iPtr, oPtr, ioPtr).cint
  echo &"f_my_struct_nim (after): i={iPtr[]}, o={oPtr[]}, io={ioPtr[]}"
