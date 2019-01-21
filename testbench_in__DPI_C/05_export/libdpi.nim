proc export_func() {.importc.}
proc export_task() {.importc.}

proc import_func() {.exportc.} =
  echo "Nim: Before calling export function"
  export_func()
  echo "Nim: After calling export function"

proc import_task(): int32 {.exportc.} =
  echo "Nim: Before calling export task"
  export_task()
  echo "Nim: After calling export task"
  return 0
  # A Nim proc mapped to a SV task needs to return a 0 or 1, else you get this error:
  # xmsim: *F,INVDIS: The import task import_task returned a value other than 1 or 0.
