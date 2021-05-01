import std/[strformat]
import svdpi

proc f_bit_sv(i: svBit; oPtr, ioPtr: ptr svBit): svBit {.importc.}

proc f_bit_nim(i: svBit; oPtr, ioPtr: ptr svBit): svBit {.exportc, dynlib.} =
  echo &"f_bit_nim: Init: i={i}, o={oPtr[]}, io={ioPtr[]}"
  oPtr[] = i + 1
  ioPtr[] = oPtr[] + 1 # io (ioPtr) is output here
  echo &"f_bit_nim: Before calling f_bit_sv: i={i}, o={oPtr[]}, io={ioPtr[]}"
  # Interestingly, as the svBit type is actually uint8, values above
  # can go above the value of 1, unlike the actual bits in SV.
  let
    svRet = f_bit_sv(i, oPtr, ioPtr)
  echo &"f_bit_nim: After calling f_bit_sv: svRet={svRet}, i={i}, o={oPtr[]}, io={ioPtr[]}"
  return ioPtr[] + 1
