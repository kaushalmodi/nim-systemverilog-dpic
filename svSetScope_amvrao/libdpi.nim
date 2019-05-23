# http://amvrao.blogspot.com/2017/08/good-uses-of-system-verilog-dpi.html
# https://www.edaplayground.com/x/34Wg
import svdpi
import std/[strformat]

var
  currentPointer: cint = 0
  startAddress: array[100, cint]
  endAddress: array[100, cint]
  scopes: array[100, cstring]

proc sv_write_reg(address, value: cint) {.importc.}

proc findAddressPointer(address: cint): cint =
  result = -1.cint
  for i in 0.cint ..< currentPointer:
    if ((address >= startAddress[i]) and (address <= endAddress[i])):
      return i

proc nim_write_reg(address, value: cint) {.exportc.} =
  let
    addrPtr = findAddressPointer(address)
  if addrPtr == -1:
    echo &"Error: Invalid address found: {address}"
    return

  # set the scope to the specific instance.
  discard svSetScope(svGetScopeFromName(scopes[addrPtr]))
  sv_write_reg(address, value)

proc registerMe(startAddr, endAddr: cint) {.exportc.} =
  # Get Scope....
  startAddress[currentPointer] = startAddr
  endAddress[currentPointer] = endAddr
  scopes[currentPointer] = svGetNameFromScope(svGetScope())
  echo &"[Scope {scopes[currentPointer]}] Registering addresses {startAddr} to {endAddr}\n"
  currentPointer += 1.cint

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
