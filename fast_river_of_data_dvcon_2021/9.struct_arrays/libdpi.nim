import std/[strformat, strutils]
import svdpi

const
  numElems = 3

type
  MyStruct = object # 88 bytes
    twoBits: array[svPackedDataNElems(2), svBitVecVal]     # 4 bytes
    twoLogics: array[svPackedDataNElems(2), svLogicVecVal] # 8 bytes
    sevenBits: array[svPackedDataNElems(7), svBitVecVal]     # 4 bytes
    sevenLogics: array[svPackedDataNElems(7), svLogicVecVal] # 8 bytes
    thirtytwoBits: array[svPackedDataNElems(32), svBitVecVal]     # 4 bytes
    thirtytwoLogics: array[svPackedDataNElems(32), svLogicVecVal] # 8 bytes
    sixtyfiveBits: array[svPackedDataNElems(65), svBitVecVal]     # 12 bytes
    sixtyfiveLogics: array[svPackedDataNElems(65), svLogicVecVal] # 24 bytes
    b: uint8       # 1 byte -> 2 bytes, because looks like any field takes up a minimum of 2 bytes in memory.
    si: cshort     # 2 bytes
    i: cint        # 4 bytes
    li: clonglong  # 8 bytes
  WrapStruct = object
    sa: array[numElems, MyStruct]

const
  sizeMyStruct = sizeof(MyStruct)

proc f_array_of_struct_nim(ioPtr: ptr WrapStruct): cint {.exportc, dynlib.} =
  echo &"f_array_of_struct_nim: size of MyStruct = {sizeMyStruct} bytes"
  for i, x in ioPtr[].sa:
    let
      pntrInt = cast[int](unsafeAddr ioPtr[].sa[i])
    for offset in 0 ..< sizeMyStruct:
      let
        pntr = cast[ptr int8](pntrInt + offset)
      echo &"{pntrInt + offset} = {pntr[]:>4} | 0x{pntr[].toHex()}"

    echo &" .. f_array_of_struct_nim (before): io.sa[{i}]: {ioPtr[].sa[i]}"
    inc ioPtr[].sa[i].b
    inc ioPtr[].sa[i].si
    inc ioPtr[].sa[i].i
    inc ioPtr[].sa[i].li
    echo &" .. f_array_of_struct_nim (after) : io.sa[{i}]: {ioPtr[].sa[i]}"
  return 0
