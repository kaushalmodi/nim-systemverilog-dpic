proc wrapper_function(): cint {.importc, discardable.}

proc from_nim() {.exportc.} =
  echo "I am in Nim"
  wrapper_function()
