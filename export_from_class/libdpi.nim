proc wrapper_function(): cint {.importc, discardable.}

proc from_nim() {.exportc, dynlib.} =
  echo "I am in Nim"
  wrapper_function()
