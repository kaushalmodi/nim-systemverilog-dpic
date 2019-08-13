# Time-stamp: <2019-08-13 09:13:36 kmodi>
# https://verificationacademy.com/resources/technical-papers/dpi-redux-functionality-speed-optimization

import std/[strformat]
import svdpi

# Signature / header lines for the functions/tasks defined in SV.
proc sv_print_scope(value: cint) {.importc.}
proc sv_consume_time(delay: cint): cint {.importc, discardable.}

proc addFunction(a, b: cint; c: ptr cint): cint {.exportc.} =
  #                             ^^^ - c is an output on SV side, so it becomes a ptr here.
  let
    scopeName = svGetNameFromScope(svGetScope())
  c[] = a + b
  echo &"Nim: {scopeName}.addFunction({a}, {b}, {c[]})"
  sv_print_scope(c[])
  return 0

proc addTask(a, b: cint; c: ptr cint): cint {.exportc.} =
  let
    scopeName = svGetNameFromScope(svGetScope())
  c[] = a + b
  echo &"Nim: {scopeName}.addTask({a}, {b}, {c[]})"
  sv_consume_time(10)
  sv_consume_time(10)
  sv_print_scope(c[])
  sv_consume_time(10)
  return 0
