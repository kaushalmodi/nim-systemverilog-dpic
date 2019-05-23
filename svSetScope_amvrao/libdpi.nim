# http://amvrao.blogspot.com/2017/08/good-uses-of-system-verilog-dpi.html
# https://www.edaplayground.com/x/34Wg
import svdpi
import std/[strformat]

type
  ScopeInfo = object
    startAddress: cint
    endAddress: cint
    scopeName: string

var
  scopes: seq[ScopeInfo]

proc sv_write_reg(address, value: cint) {.importc.}

proc findAddressPointer(address: cint): int =
  result = -1
  for i in 0 .. scopes.len:
    if ((address >= scopes[i].startAddress) and (address <= scopes[i].endAddress)):
      return i

proc nim_write_reg(address, value: cint) {.exportc.} =
  let
    addrPtr = findAddressPointer(address)
  if addrPtr == -1:
    echo &"Error: Invalid address found: {address}"
    return

  let
    currentScopeName = scopes[addrPtr].scopeName
  echo &"[nim_write_reg] Address {address} found in scope = {currentScopeName}"
  # set the scope to the specific instance.
  discard svSetScope(svGetScopeFromName(currentScopeName.cstring))
  sv_write_reg(address, value)
  echo ""

proc registerMe(startAddr, endAddr: cint) {.exportc.} =
  let
    currentScopeName = $svGetNameFromScope(svGetScope())
  scopes.add(ScopeInfo(startAddress: startAddr,
                       endAddress: endAddr,
                       scopeName: currentScopeName))
  echo &"[Scope {currentScopeName}] Registering addresses {startAddr} to {endAddr}"
  # echo &"scopes = {scopes}"
  echo ""

#[
**Original C++ code**

#include <iostream>
#include <svdpi.h>
#include <string.h>

using namespace std;

char scopes[100][100];
int startAddress[100];
int endAddress[100];
int currentPointer = 0;

int findAddressPointer(int addr);

extern "C" void sv_write_reg(int addr, int value);
extern "C" void c_write_reg(int addr, int value) {
  int pointer = findAddressPointer(addr);
  if(pointer != -1) {
    // set the scope to the specific instance.
    svSetScope(svGetScopeFromName(scopes[pointer]));
    write_reg(addr,value);
  }
  else {
    cout << "Invalid address found: " << addr << endl;
  }

# }

extern "C" void registerMe(int startAddr, int endAddr) {
  // Get Scope....
  startAddress[currentPointer] = startAddr;
  endAddress[currentPointer] = endAddr;
  strcpy(scopes[currentPointer] ,svGetNameFromScope(svGetScope()));
  cout << "Registering Address: " << startAddr << " to " << endAddr << scopes[currentPointer] << endl;
  currentPointer++;

# }

int findAddressPointer(int addr) {
  for(int i=0;i<currentPointer;i++) {
    if((addr >= startAddress[i]) && (addr <= endAddress[i])) {
      return(i);
    }
  }
  return(-1);
}
]#
