# Time-stamp: <2023-04-05 10:30:56 kmodi>

import std/[strformat]

proc f_big_data_2d_nim(sizeX, sizeY: cint; iPtr, ioPtr: pointer): cint {.exportc, dynlib.} =
  let
    size = sizeX * sizeY
    iIntArrPtr = cast[ptr UncheckedArray[cint]](iPtr)
    ioIntArrPtr = cast[ptr UncheckedArray[cint]](ioPtr)
  for idx in 0 ..< size:
    ioIntArrPtr[][idx] = iIntArrPtr[][idx] + idx
    # echo &" .. iIntArr[{idx}]  = {iIntArrPtr[][idx]}, ioIntArr[{idx}] = {ioIntArrPtr[][idx]}"

  return 0
