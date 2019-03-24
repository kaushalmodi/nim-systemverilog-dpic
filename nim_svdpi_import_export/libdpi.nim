# Time-stamp: <2019-03-24 14:56:34 kmodi>
# https://verificationacademy.com/resources/technical-papers/dpi-redux-functionality-speed-optimization

import svdpi
import strformat

# Signature / header lines for the functions/tasks defined in SV.
proc sv_print_scope(value: cint): cint {.importc, discardable.}
proc sv_consume_time(d: cint): cint {.importc, discardable.}

proc nimAddFunction(a, b: cint; c: ref cint): cint {.exportc.} =
  #                                ^^^ - c is an output on SV side, so it becomes a ref here.
  let
    scopeName = svGetNameFromScope(svGetScope())
  c[] = a + b
  echo fmt"Nim: {scopeName}.nimAddFunction({a}, {b}, {c[]})"
  sv_print_scope(c[])
  return 0

proc nimAddTask(a, b: cint; c: ref cint): cint {.exportc.} =
  let
    scopeName = svGetNameFromScope(svGetScope())
  c[] = a + b
  echo fmt"Nim: {scopeName}.nimAddTask({a}, {b}, {c[]})"
  sv_consume_time(10)
  sv_consume_time(10)
  sv_print_scope(c[])
  sv_consume_time(10)
  return 0
