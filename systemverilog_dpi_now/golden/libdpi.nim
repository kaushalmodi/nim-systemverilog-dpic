import svdpi
import strformat

proc vl_task(inp1, inp2: cint, vl_answer: var cint) {.importc.}

const
  Max = 10

proc c_task(inp1, inp2: cint; c_answer: var cint) {.exportc.} =
  c_answer = inp1 * inp2

proc c_compare(inp1, inp2: cint) {.exportc.} =
  var
    c_answer, vl_answer: cint

  vl_task(inp1, inp2, vl_answer)
  c_task(inp1, inp2, c_answer)

  if c_answer != vl_answer:
    echo fmt"Error: MISMATCH ({inp1}, {inp2}) vl<{vl_answer}> != c<{c_answer}>"

proc c_test(): cint {.exportc.} =

  echo "Running .."
  for inp1 in 0 ..< Max:
    for inp2 in 0 .. Max:
      c_compare(inp1.cint, inp2.cint)

  echo "... done."
  return 0
