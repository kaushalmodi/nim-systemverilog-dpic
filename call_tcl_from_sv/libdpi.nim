import std/[strformat, strutils]
import cdns_cfc
from svvpi import vpiEcho

proc cfcGetTclOut*(cmd: cstring): string =
  # The cfcExecuteCommand() has to be preceeded by
  # cfcCaptureOutput() if you want cfcGetOutput() to capture the
  # output.
  cfcCaptureOutput()
  cmd.cfcExecuteCommand()
  result = ($cfcGetOutput()).strip()
  #         ^ `$` copies cstring to Nim string
  # Do cfcReleaseOutput() at the end.
  cfcReleaseOutput()

proc call_tcl(cmd: cstring) {.exportc, dynlib.} =
  vpiEcho &"[tcl out] `{cfcGetTclOut(cmd)}'"
