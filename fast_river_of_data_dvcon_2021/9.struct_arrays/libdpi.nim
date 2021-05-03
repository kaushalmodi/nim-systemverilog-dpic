import std/[strformat, strutils]
import svdpi

type
  # Mon May 03 13:44:14 EDT 2021 - kmodi
  # For whatever reason, the order of elements of SV packed structs gets flipped on
  # the C side. So the order of the elements on the Nim (C) side are reverse of those
  # declared in SV.
  MyStruct = object
    li: clonglong
    i: cint
    si: cshort
    b: uint8
    # sixtyfiveRegs: array[65, svLogicVecVal]
    # sixtyfiveBits: array[65, svBitVecVal]
    # thirtytwoRegs: array[32, svLogicVecVal]
    # thirtytwoBits: array[32, svBitVecVal]
    # sevenRegs: array[7, svLogicVecVal]
    # sevenBits: array[7, svBitVecVal]
    # twoRegs: array[2, svLogicVecVal]
    # twoBits: array[2, svBitVecVal]
  WrapStruct = object
    sa: array[10, MyStruct]

proc f_array_of_struct_nim(ioPtr: ptr WrapStruct): cint {.exportc, dynlib.} =
  for i, x in ioPtr[].sa:
    echo &"f_array_of_struct_nim (before): io.sa[{i}].b = {x.b}, io.sa[{i}].si = {x.si}, io.sa[{i}].i = {x.i}, io.sa[{i}].li = {x.li}"
    inc ioPtr[].sa[i].b
    inc ioPtr[].sa[i].si
    inc ioPtr[].sa[i].i
    inc ioPtr[].sa[i].li
    echo &"f_array_of_struct_nim (after): io.sa[{i}].b = {ioPtr[].sa[i].b}, io.sa[{i}].si = {ioPtr[].sa[i].si}, io.sa[{i}].i = {ioPtr[].sa[i].i}, io.sa[{i}].li = {ioPtr[].sa[i].li}"
  return 0
