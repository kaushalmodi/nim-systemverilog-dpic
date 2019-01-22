import svdpi
import strformat

type
  PciCfgDirection = enum
    pciCfgRead = 1
    pciCfgWrite
  PciCmd = object
    address: cint
    cb_e: PciCfgDirection
    databuffer: cint

proc pci_transaction(cmd: var PciCmd) {.importc.}

proc c_test(): cint {.exportc.} =
  var
    cmd: PciCmd

  echo "Running .."

  # Program a series of PCI tests, configure the registers in the
  # hardware, perform tests.

  cmd = PciCmd(address: 0x30,
               cb_e: pciCfgRead,
               databuffer: 0)

  # Call HW
  echo fmt" Nim: Sending PCI command {cmd} to hardware .."
  pci_transaction(cmd)

  # Check results
  echo fmt" Nim: read config databuffer = {cmd.databuffer}"

  # ...

  echo "... done."

  return 0 # tasks send a return value of 0
