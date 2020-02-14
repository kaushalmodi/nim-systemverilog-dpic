func add(a, b: cint): cint {.exportc, dynlib.} =
  return a + b
