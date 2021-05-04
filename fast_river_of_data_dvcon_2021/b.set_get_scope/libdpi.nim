# Time-stamp: <2021-05-04 17:21:29 kmodi>

import std/[strformat]
import svdpi

proc f_scopetest_sv() {.importc.}

proc switchToScope(newScope: svScope) =
  let
    prevScope = svSetScope(newScope)
  echo &"f_scopetest_nim: Switched from {svGetNameFromScope(prevScope)} to {svGetNameFromScope(newScope)}"
  f_scopetest_sv()

proc f_scopetest_nim() {.exportc, dynlib.} =
  var
    scope = svGetScope()
  let
    # That $ is important! As the C impl of svGetNameFromScope owns
    # the returned C string memory location (because its return type
    # is const char*), we need to copy that to Nim string if we want
    # to keep that copy, otherwise, each call to svGenNameFromScope
    # will keep on overwriting the variable as the C impl saves that
    # function's return value to the same location --
    # https://forum.nim-lang.org/t/7924#50456
    origScopeName = $svGetNameFromScope(scope)

  switchToScope(scope)

  # Switch to the other_module scope
  scope = svGetScopeFromName("top.u_other_module".cstring)
  switchToScope(scope)

  # Go back to the original scope
  scope = svGetScopeFromName(origScopeName)
  switchToScope(scope)
