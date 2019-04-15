# Time-stamp: <2019-04-15 10:06:44 kmodi>
# https://verificationacademy.com/resources/technical-papers/dpi-redux-functionality-speed-optimization

import svdpi
import strformat

# Signature / header lines for the functions/tasks defined in SV.
proc sv_print_scope(value: cint) {.importc.}
proc sv_consume_time(d: cint): cint {.importc, discardable.}

proc nimAddFunction(a, b: cint; c: ptr cint): cint {.exportc.} =
  #                                ^^^ - c is an output on SV side, so it becomes a ptr here.
  let
    scopeName = svGetNameFromScope(svGetScope())
  c[] = a + b
  echo fmt"Nim: {scopeName}.nimAddFunction({a}, {b}, {c[]})"
  sv_print_scope(c[])
  return 0

proc nimAddTask(a, b: cint; c: ptr cint): cint {.exportc.} =
  let
    scopeName = svGetNameFromScope(svGetScope())
  c[] = a + b
  echo fmt"Nim: {scopeName}.nimAddTask({a}, {b}, {c[]})"
  sv_consume_time(10)
  sv_consume_time(10)
  sv_print_scope(c[])
  sv_consume_time(10)
  return 0
