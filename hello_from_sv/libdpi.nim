proc hello_from_sv() {.importc.}

proc hello_from_nim() {.exportc, dynlib.} =
  hello_from_sv()
