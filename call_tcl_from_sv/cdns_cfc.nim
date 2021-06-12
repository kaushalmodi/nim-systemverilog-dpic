## Nim wrapper for Cadence Design Systems C Function Call (CFC) library: cfclib.h
# ${XCELIUM_ROOT}/../include/cdclib.h

proc cfcCaptureOutput*() {.importc, cdecl.}
proc cfcExecuteCommand*(cmd: cstring) {.importc, cdecl.}
proc cfcGetOutput*(): cstring {.importc, cdecl.}
proc cfcReleaseOutput*() {.importc, cdecl.}

proc cfcCurrentScope*(): cstring {.importc, cdecl.}
proc cfcWriteMessage*(msg: cstring) {.importc, cdecl.}
proc cfcReadline*(prompt: cstring): cstring {.importc, cdecl.}
proc cfcSubmitCommand*(cmd: cstring) {.importc, cdecl.}
proc cfcEnableInterrupt*() {.importc, cdecl.}
proc cfcCheckInterrupt*(): cint {.importc, cdecl.}
proc cfcDisableInterrupt*() {.importc, cdecl.}
proc cfcUnusedBreakName*(prefix: cstring): cstring {.importc, cdecl.}
