// http://amvrao.blogspot.com/2017/08/good-uses-of-system-verilog-dpi.html
// https://www.edaplayground.com/x/34Wg

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
extern "C" void nim_write_reg(int addr, int value) {
  int pointer = findAddressPointer(addr);
  if(pointer != -1) {
    // set the scope to the specific instance.
    svSetScope(svGetScopeFromName(scopes[pointer]));
    sv_write_reg(addr,value);
  }
  else {
    cout << "Invalid address found: " << addr << endl;
  }

}

extern "C" void registerMe(int startAddr, int endAddr) {
  // Get Scope....
  startAddress[currentPointer] = startAddr;
  endAddress[currentPointer] = endAddr;
  strcpy(scopes[currentPointer] ,svGetNameFromScope(svGetScope()));
  cout << "Registering Address: " << startAddr << " to " << endAddr << scopes[currentPointer] << endl;
  currentPointer++;

}

int findAddressPointer(int addr) {
  for(int i=0;i<currentPointer;i++) {
    if((addr >= startAddress[i]) && (addr <= endAddress[i])) {
      return(i);
    }
  }
  return(-1);
}
