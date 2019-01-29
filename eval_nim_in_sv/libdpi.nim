from os import getEnv, removeFile, fileExists
from osproc import execCmdEx
from strutils import strip, split, removeSuffix
from strformat import fmt

proc nim_eval_string(code: cstring) {.exportc.} =
  ## Evaluate the Nim code passed as string.
  let
    user = if getEnv("USER")=="":
             "temp_user"
           else:
             getEnv("USER")
    (tmpNimFileRaw, _) = execCmdEx(fmt"mktemp /tmp/temp_code_{user}_XXXXXX.nim")
    tmpNimFile = tmpNimFileRaw.strip() # string returned by execCmdEx would have a trialing newline, remove it!
    sep = fmt"=== {tmpNimFile} ==="
    sepEcho = fmt"""echo "{sep}"{'\n'}"""
    nimCmd = fmt"nim c -r {tmpNimFile}"
  # echo fmt"Creating temp code file: {tmpNimFile}"
  writeFile(tmpNimFile, fmt"{sepEcho}{code}")
  echo fmt"""[Nim] Running "{nimCmd}" .."""
  try:
    var
      (output, _) = execCmdEx(nimCmd)  # Execute it
    output.removeSuffix("\n")
    let
      outputParts = output.split(sep & "\n", maxsplit = 1)
    echo outputParts[1]
    tmpNimFile.removeFile()
  except:
    echo fmt"  [Error] Unable to run the above command."
  finally:
    # Clean up the temp files
    var
      binFile = tmpNimFile
    binFile.removeSuffix(".nim")
    if binFile.fileExists():
      binFile.removeFile()
