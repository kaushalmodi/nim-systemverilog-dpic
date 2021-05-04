# Time-stamp: <2021-05-04 02:02:30 kmodi>

import std/[strformat]

proc f_big_data_nim(size: cint; iPtr, ioPtr: pointer): cint {.exportc, dynlib.} =
  let
    iIntArrPtr = cast[ptr UncheckedArray[cint]](iPtr)
    ioIntArrPtr = cast[ptr UncheckedArray[cint]](ioPtr)
  for idx in 0 ..< size:
    ioIntArrPtr[][idx] = iIntArrPtr[][idx] + idx
  return 0
