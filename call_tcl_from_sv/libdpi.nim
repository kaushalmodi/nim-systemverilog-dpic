import std/[strformat, strutils, sequtils]
import cdns_cfc
import svdpi

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
  cmd.cfcExecuteCommand()

proc get_tcl_output(cmd: cstring; dynArrPtr: svOpenArrayHandle) {.exportc, dynlib.} =
  let
    tclOutputSeq = cmd.cfcGetTclOut().split().mapIt(it.cstring)
  svSeqToSVDynArr1[cstring](tclOutputSeq, dynArrPtr)
