# Time-stamp: <2021-05-03 22:22:11 kmodi>

import std/[strformat]
import svdpi

proc f_scopetest_sv() {.importc.}

proc switchToScope(newScope: svScope) =
  let
    prevScope = svSetScope(newScope)
  # See below note on why the below line is commented out.
  # echo &"f_scopetest_nim: Switched from {svGetNameFromScope(prevScope)} to {svGetNameFromScope(newScope)}"
  f_scopetest_sv()

proc f_scopetest_nim() {.exportc, dynlib.} =
  var
    scope = svGetScope()
  let
    origScopeName = svGetNameFromScope(scope)

  switchToScope(scope)
  echo &"origScopeName = {origScopeName}"

  # Switch to the other_module scope
  scope = svGetScopeFromName("top.u_other_module".cstring)
  switchToScope(scope)
  echo &"origScopeName = {origScopeName}"

  # Go back to the original scope
  scope = svGetScopeFromName(origScopeName)
  switchToScope(scope)
  echo &"origScopeName = {origScopeName}"

# Mon May 03 22:09:22 EDT 2021 - kmodi
# NOTE:
#   With line 12 uncommented, we see the immutable `origScopeName' change its value
#   after the scope switches to top.u_other_module, and the scope still remains
#   top.u_other_module after the last switch, which is wrong!
#
#   xcelium> run
#   f_scopetest_nim: Switched from top to top
#   In top.f_scopetest_sv
#
#   origScopeName = top
#   f_scopetest_nim: Switched from top to top.u_other_module
#   In top.u_other_module.f_scopetest_sv
#
#   origScopeName = top.u_other_module
#   f_scopetest_nim: Switched from top.u_other_module to top.u_other_module
#   In top.u_other_module.f_scopetest_sv
#
#   origScopeName = top.u_other_module
#
# But if line 12 is commented out, the final scope is correct! It doesn't make sense ..
# The calls to `svGetNameFromScope' in that echo statement are messing up things.
#
#   xcelium> run
#   In top.f_scopetest_sv
#
#   origScopeName = top
#   In top.u_other_module.f_scopetest_sv
#
#   origScopeName = top
#   In top.f_scopetest_sv
#
#   origScopeName = top
