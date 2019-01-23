import svdpi
import zip/zlib
import strscans
import strformat

proc vl_task(inp1, inp2: cint; result: var cint) {.importc.}

proc c_test(): cint {.exportc.} =
  const
    # lineMax: int32 = 1024
    fileName = "compressed.txt.gz"
  var
    tries, matches: int
    vl_answer: cint
    expected_answer, inp1, inp2: int
    line: string

  echo fmt"zlib version: {zlibVersion()}"
  echo "Running .."

  let
    f = gzopen(fileName, "rb")

  if f == nil:
    stderr.writeLine fmt"c_test(): Error - cannot open file ({fileName})"
    quit 1

  while (f.gzeof() == 0):
    # Tue Jan 22 22:27:46 EST 2019 - kmodi
    # Below does not work, the file pointer never increments and line
    # value always remains blank.
    # discard f.gzgets(line, lineMax)
    # line[strlen(line)-1] = 0 # what does this do? why set the last char to 0? maybe null?
    line = ""
    while true:
      var
        c = chr(f.gzgetc())
      if (f.gzeof() != 0 or
             ord(c) == 10):         # new line
        break
      line.add($c)
    when defined(debug):
      echo fmt"line = `{$line}'"

    discard scanf(line, "$i $i $i", inp1, inp2, expected_answer)
    vl_task(inp1.cint, inp2.cint, vl_answer)

    when defined(debug):
      echo fmt"try {tries} gzeof {f.gzeof()}"

    tries += 1
    if expected_answer.cint != vl_answer:
      echo fmt"Error: MISMATCH ({inp1}, {inp2}) vl<{vl_answer}> != c<{expected_answer}>"
    else:
      matches += 1

  echo fmt"...done. {matches}/{tries} matches."

  return 0 # tasks send a return value of 0
