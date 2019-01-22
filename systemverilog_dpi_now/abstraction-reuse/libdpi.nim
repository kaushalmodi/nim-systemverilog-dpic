import svdpi
import strformat

proc t_add(z: var uint32; a, b: uint32) {.importc.}

var
  hw_matches, total_tries: uint32

proc c_task(inp1, inp2: uint32; c_answer: var uint32) {.exportc.} =
  c_answer = (inp1 + inp2) and 0x0f # limit output to 4-bits

proc c_compare(inp1, inp2: uint32) {.exportc.} =
  var
    c_answer, vl_hw_answer: uint32

  c_task(inp1, inp2, c_answer)
  t_add(vl_hw_answer, inp1, inp2)

  if (c_answer == vl_hw_answer):
    hw_matches += 1
  else:
    echo fmt"Error: MISMATCH hw({inp1}, {inp2}) vl<{vl_hw_answer}> != c<{c_answer}>"

proc c_test(): cint {.exportc.} =
  hw_matches = 0
  total_tries = 0

  echo "Running .."
  for inp1 in 0 .. 15:
    for inp2 in 0 .. 15:
      c_compare(inp1.uint32, inp2.uint32)
      total_tries += 1

  echo fmt"{hw_matches}/{total_tries} hw matches. done."
  return 0
