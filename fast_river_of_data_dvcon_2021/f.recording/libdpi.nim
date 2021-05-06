# Time-stamp: <2021-05-06 00:42:37 kmodi>

import std/[strformat, random]
import svdpi

var
  rs: Rand
  recordingEnabled = true

type
  MyObj = object
    b: svBit
    l: svLogic
    i: cint
    li: clonglong

proc record_an_int(i: cint) {.importc.}
proc record_my_struct(iPtr: ptr MyObj) {.importc.}
proc tictoc(times: cint): cint {.importc.}

proc disable_recording() {.exportc, dynlib.} =
  recordingEnabled = false

proc init_rand(seed: cint) {.exportc, dynlib.} =
  echo &"Random seed = {seed}"
  rs = initRand(seed.int) # Init the RNG with the seed provided from the SV side

proc run_nim_code1(): cint {.exportc, dynlib.} =
  var
    k = 0
    s = MyObj()

  while true:
    # Update `s'
    s.b = rs.rand(1).svBit
    s.l = rs.rand(3).svLogic
    inc(s.i, rs.rand(2))
    inc(s.li, rs.rand(10))
    if s.i > 50:
      s.i = -50
    if s.li > 500:
      s.li = -500

    if not recordingEnabled:
      break
    discard tictoc(1) # wait for 1 clock edge
    withScope "top.u_recorder_1":
      record_my_struct(addr s) # Record Nim variables
      record_an_int(k.cint)
    inc k
  return 0

proc run_nim_code2(): cint {.exportc, dynlib.} =
  var
    k = 0
    s = MyObj()

  while true:
    # Update `s'
    s.b = rs.rand(1).svBit
    s.l = rs.rand(3).svLogic
    inc(s.i, rs.rand(5))
    inc(s.li, rs.rand(100))
    if s.i > 100:
      s.i = -100
    if s.li > 1000:
      s.li = -1000

    if not recordingEnabled:
      break
    discard tictoc(1) # wait for 1 clock edge
    withScope "top.u_recorder_2":
      record_my_struct(addr s) # Record Nim variables
      record_an_int(k.cint)
    inc k
  return 0
