import svdpi
import strformat

proc string_sv2nim(str: cstring) {.exportc, dynlib.} =
  echo fmt"  Nim: {str}"

proc string_nim2sv(): cstring {.exportc, dynlib.} =
  result = "HELLO: This string is created in Nim"
