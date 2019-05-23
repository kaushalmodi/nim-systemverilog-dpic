# http://amvrao.blogspot.com/2017/08/good-uses-of-system-verilog-dpi.html
# https://www.edaplayground.com/x/34Wg
import svdpi
import std/[strformat]

const
  maxInstances = 100

var
  currentPointer: cint = 0
  startAddress: array[maxInstances, cint]
  endAddress: array[maxInstances, cint]
  scopes: array[maxInstances, string]

proc sv_write_reg(address, value: cint) {.importc.}

proc findAddressPointer(address: cint): cint =
  # echo &"[findAddressPointer] address = {address}, currentPointer = {currentPointer}"
  result = -1.cint
  for i in 0.cint .. currentPointer:
    if ((address >= startAddress[i]) and (address <= endAddress[i])):
      # echo &"[findAddressPointer] match found in instance {i}"
      return i

proc nim_write_reg(address, value: cint) {.exportc.} =
  let
    addrPtr = findAddressPointer(address)
  if addrPtr == -1:
    echo &"Error: Invalid address found: {address}"
    return

  let
    currentScopeName = scopes[addrPtr]
  echo &"[nim_write_reg] Address {address} found in instance {addrPtr}; scope = {currentScopeName}"
  # set the scope to the specific instance.
  discard svSetScope(svGetScopeFromName(currentScopeName.cstring))
  sv_write_reg(address, value)
  echo ""

proc registerMe(startAddr, endAddr: cint) {.exportc.} =
  # echo &"Current pointer = {currentPointer}"
  startAddress[currentPointer] = startAddr
  endAddress[currentPointer] = endAddr
  # Get Scope....
  scopes[currentPointer] = $svGetNameFromScope(svGetScope())
  echo &"[Scope {scopes[currentPointer]}] Registering addresses {startAddr} to {endAddr}\n"
  currentPointer += 1.cint
  # echo &"scopes debug: {scopes[0 .. 2]}"

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
