import std/[strformat]
import svdpi

proc f_bitvector_sv(iPtr, oPtr, ioPtr: ptr svBitVecVal): cint {.importc.}

proc f_bitvector_nim(iPtr, oPtr, ioPtr: ptr svBitVecVal): cint {.exportc, dynlib.} =
  oPtr[] = iPtr[] + 1
  ioPtr[] = oPtr[] + 1
  discard f_bitvector_sv(iPtr, oPtr, ioPtr)
  result = (ioPtr[] + 1).cint
  echo &"f_bitvector_nim: i={iPtr[]}, o={oPtr[]}, io={ioPtr[]}"
