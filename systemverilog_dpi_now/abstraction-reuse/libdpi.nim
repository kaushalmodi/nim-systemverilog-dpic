import svdpi
import strformat

proc t_add(z: var cuint; a, b: cuint) {.importc.}

var
  hw_matches, total_tries: cuint

proc c_task(inp1, inp2: cuint; c_answer: var cuint) {.exportc.} =
  c_answer = (inp1 + inp2) and 0x0f # limit output to 4-bits

proc c_compare(inp1, inp2: cuint) {.exportc.} =
  var
    c_answer, vl_hw_answer: cuint

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
      c_compare(inp1.cuint, inp2.cuint)
      total_tries += 1

  echo fmt"{hw_matches}/{total_tries} hw matches. done."
  return 0
