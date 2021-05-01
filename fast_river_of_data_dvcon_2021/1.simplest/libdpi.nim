import std/[strformat]

proc f_int_sv(i: cint) {.importc.}

proc f_int_nim(i: cint) {.exportc, dynlib.} =
  echo &"Hello from f_int_nim ({i})"
  f_int_sv(i + 1)
