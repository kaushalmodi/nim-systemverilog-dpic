import std/[strformat]

const
  svArraySize = 10

type
  IntArray = array[svArraySize, cint]

proc f_array_of_int_sv(iPtr, oPtr, ioPtr: ptr IntArray): int {.importc.}

proc f_array_of_int_nim(iPtr, oPtr, ioPtr: ptr IntArray): int {.exportc, dynlib.} =
  for idx in 0 ..< svArraySize:
    oPtr[][idx] = oPtr[][idx] + iPtr[][idx] + 1
    ioPtr[][idx] = ioPtr[][idx] + oPtr[][idx] + 1

  let
    result = f_array_of_int_sv(iPtr, oPtr, ioPtr)
  echo &"f_array_of_int_nim: i={iPtr[]}"
  echo &"f_array_of_int_nim: o={oPtr[]}"
  echo &"f_array_of_int_nim: io={ioPtr[]}"
