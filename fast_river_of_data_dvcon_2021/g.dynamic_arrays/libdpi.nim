# Time-stamp: <2021-05-04 11:30:53 kmodi>

import std/[strformat]
import svdpi

proc printSVIntDynArr(str: string, arrPtr: svOpenArrayHandle) =
  echo &".. from Nim: {str}: {svSVDynArr1ToSeq[cint](arrPtr)}"

proc f_openarray_1d_nim(iPtr, oPtr, ioPtr: svOpenArrayHandle): cint {.exportc, dynlib.} =
  let
    arrLen = svSize(iPtr, 1) # All open arrays are of the same size
  var
    iIntArrPtr = cast[ptr UncheckedArray[cint]](svGetArrayPtr(iPtr))
    oIntArrPtr = cast[ptr UncheckedArray[cint]](svGetArrayPtr(oPtr))
    ioIntArrPtr = cast[ptr UncheckedArray[cint]](svGetArrayPtr(ioPtr))

  printSVIntDynArr("before", iPtr)
  printSVIntDynArr("before", oPtr)
  printSVIntDynArr("before", ioPtr)

  for x in 0 ..< arrLen:
    iIntArrPtr[][x] += 1
    oIntArrPtr[][x] = 0

  # Set index 3 of io openarray to 999
  ioIntArrPtr[][3] = 999

  printSVIntDynArr("after", iPtr)
  printSVIntDynArr("after", oPtr)
  printSVIntDynArr("after", ioPtr)

  return 0
