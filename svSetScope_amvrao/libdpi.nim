# http://amvrao.blogspot.com/2017/08/good-uses-of-system-verilog-dpi.html
# https://www.edaplayground.com/x/34Wg

import svdpi
import std/[strformat]

type
  ScopeInfo = object
    startAddress: cint
    endAddress: cint
    name: string

var
  scopes: seq[ScopeInfo]

proc sv_write_reg(address, value: cint) {.importc.}

proc getScopeIndex(address: cint): int =
  result = -1
  for i in 0 ..< scopes.len:
    if ((address >= scopes[i].startAddress) and (address <= scopes[i].endAddress)):
      return i

proc nim_write_reg(address, value: cint) {.exportc.} =
  let
    idx = getScopeIndex(address)
  if idx == -1:
    echo &"Error: Invalid address found: {address}"
    return

  echo &"[nim_write_reg] Address {address} found in scope = {scopes[idx].name}"
  # set the scope to the specific instance.
  discard svSetScope(svGetScopeFromName(scopes[idx].name.cstring))
  sv_write_reg(address, value)
  echo ""

proc registerMe(startAddr, endAddr: cint) {.exportc.} =
  scopes.add(ScopeInfo(startAddress: startAddr,
                       endAddress: endAddr,
                       name: $svGetNameFromScope(svGetScope())))
  echo &"Registered new scope: {scopes[^1]}"
  echo ""
