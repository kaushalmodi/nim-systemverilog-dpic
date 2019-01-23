import svdpi
import zip/zlib
import strscans
import strformat

proc vl_task(inp1, inp2: cint; result: var cint) {.importc.}

proc c_test(): cint {.exportc.} =
  const
    lineMax: int32 = 1024
    fileName = "compressed.txt.gz"
  var
    tries, matches: int
    vl_answer: cint
    expected_answer, inp1, inp2: int
    # https://irclogs.nim-lang.org/23-01-2019.html#04:56:22
    lineArr: array[lineMax, char]  # Initialize a char array ..
    line: Pbytef = addr lineArr[0] # and point `line' to that char
    # array.  Pbytef is a type alias to cstring and cstrings are not
    # auto-initialized; they remain nil! So if `line' is not init like
    # above, it will always stay nil.

  echo fmt"zlib version: {zlibVersion()}"
  echo "Running .."

  let
    f = gzopen(fileName, "rb")

  if f == nil:
    stderr.writeLine fmt"c_test(): Error - cannot open file ({fileName})"
    quit 1

  while (f.gzeof() == 0):
    var
      gzgetsRet = f.gzgets(line, lineMax)
    when defined(debug):
      echo fmt"line = `{$line}', `{$gzgetsRet}'"

    discard scanf($line, "$i $i $i", inp1, inp2, expected_answer)
    vl_task(inp1.cint, inp2.cint, vl_answer)

    tries += 1
    when defined(debug):
      echo fmt"try {tries} gzeof {f.gzeof()}"

    if expected_answer.cint != vl_answer:
      echo fmt"Error: MISMATCH ({inp1}, {inp2}) vl<{vl_answer}> != c<{expected_answer}>"
    else:
      matches += 1

  echo fmt"...done. {matches}/{tries} matches."

  return 0 # tasks send a return value of 0
