import std/[strformat]
import svdpi

proc get_string_arr(dynArrPtr: svOpenArrayHandle) {.exportc, dynlib.} =
  let
    sSeq = @["a".cstring, "bc", "def"]
  svSeqToSVDynArr1[cstring](sSeq, dynArrPtr)
