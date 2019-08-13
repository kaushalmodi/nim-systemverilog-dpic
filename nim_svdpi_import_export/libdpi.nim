import std/[strformat]
import svdpi

# Signature / header lines for the functions/tasks defined in SV.
proc sv_print_scope(value: cint) {.importc.}
proc sv_consume_time(delay: cint): cint {.importc, discardable.}

template add(a, b: cint; c: ptr cint) {.dirty.} =
  let
    scopeName = svGetNameFromScope(svGetScope())
  c[] = a + b
  sv_print_scope(c[])

proc addFunction(a, b: cint; c: ptr cint) {.exportc.} =
  ## Nim proc mapped to function on SV side.
  ## c is an output on SV side, so it becomes a ptr here.
  add(a, b, c)
  echo &"  Nim: {scopeName}.addFunction({a}, {b}, {c[]})"

proc addTask(a, b: cint; c: ptr cint): cint {.exportc.} =
  ## Nim proc mapped to task on SV side.
  add(a, b, c)
  sv_consume_time(100)
  echo &"  Nim: {scopeName}.addTask({a}, {b}, {c[]})"
  return 0
