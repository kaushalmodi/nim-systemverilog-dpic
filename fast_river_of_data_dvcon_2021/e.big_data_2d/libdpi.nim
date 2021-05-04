# Time-stamp: <2021-05-04 08:40:02 kmodi>

import std/[strformat]

proc f_big_data_2d_nim(size: cint; iPtr, ioPtr: pointer): cint {.exportc, dynlib.} =
  let
    iIntArrPtr = cast[ptr UncheckedArray[cint]](iPtr)
    ioIntArrPtr = cast[ptr UncheckedArray[cint]](ioPtr)
  for idx in 0 ..< size:
    ioIntArrPtr[][idx] = iIntArrPtr[][idx] + idx
    # echo &" .. iIntArr[{idx}]  = {iIntArrPtr[][idx]}, ioIntArr[{idx}] = {ioIntArrPtr[][idx]}"

  return 0
