import svdpi
import strformat

proc export_func() {.importc.}

proc import_func() {.exportc, dynlib.} =
  echo fmt"Nim: I'm called from scope {svGetNameFromScope(svGetScope())}"
  export_func()
