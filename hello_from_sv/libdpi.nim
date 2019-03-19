proc hello_from_sv() {.importc.}

proc hello_from_nim() {.exportc.} =
  hello_from_sv()
