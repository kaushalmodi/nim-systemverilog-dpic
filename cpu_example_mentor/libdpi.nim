import std/[strformat, strscans, strutils]
import svdpi

## imported procs
proc V_posedge(): int {.importc.}
proc V_init_mem(index, data: int) {.importc.}
proc V_read(address: int; dataPtr: ptr int): int {.importc.}
proc V_write(address: int; data: int): int {.importc.}

proc io_printf(formatStr: cstring) {.importc, header: "veriuser.h", varargs.}

## templates
template withScope(scopeName: untyped, body: untyped) =
  let
    newScope = svGetScopeFromName(scopeName.cstring)
    oldScope = svSetScope(newScope)
  body
  discard svSetScope(oldScope)

## memory
proc C_init_mem(index, data: int) {.exportc, dynlib.} =
  withScope "system.m1":
    V_init_mem(index, data)

## dsp
type
  Complex = object
    re: int
    im: int

const
  dspBegin = 1
  dspEnd = -1
  dspFlag = 0x210
  dspA = 0x211
  dspB = 0x213
  dspX = 0x215

proc C_dsp(id: int): int {.exportc, dynlib.} =
  # Wait for initialization
  for i in 0 ..< 10:
    discard V_posedge()

  while true:
    var
      flag = 0
      localA = Complex()
      localB = Complex()
      localX = Complex()

    while flag != dspBegin:
      discard V_read(dspFlag, addr flag)

    # Get A and B operands
    discard V_read(dspA, addr localA.re)
    discard V_read(dspA+1, addr localA.im)
    discard V_read(dspB, addr localB.re)
    discard V_read(dspB+1, addr localB.im)

    # Your algorithm here
    localX.re = (localA.re * localB.re) - (localA.im * localB.im)
    localX.im = (localA.re * localB.re) + (localA.im * localB.im)

    # Delay result by expected number of instructions
    for i in 0 ..< 2*localA.re:
      discard V_posedge()

    # Save result
    discard V_write(dspX, localX.re)
    discard V_write(dspX+1, localX.im)
    discard V_write(dspFlag, dspEnd)

## risc
const
  memSize = 0x100

type
  Mem = array[memSize, int]
  OpCode = enum
    opSKZ = (0x1, "SKZ")            # SKZ   SKip  if accumulator is Zero
    opADD = (0x2, "ADD")            # ADD   ADD   m[address] to accumulator
    opSUB = (0x3, "SUB")            # SUB   SUB   m[address] with accumulator
    opXOR = (0x4, "XOR")            # XOR   XOR   m[address] with accumulator
    opLDA = (0x5, "LDA")            # LDA   LoaD  m[address] into Accumulator
    opSTA = (0x6, "STA")            # STA   STore Accumulator into m[address]
    opJMP = (0x7, "JMP")            # JMP   JuMP  to address
    opJSR = (0x8, "JSR")            # JSR   JuMP  to Subroutine
    opJMI = (0x9, "JMI")            # JMI   JuMp  Indirect to m[address]
    opLDI = (0xA, "LDI")            # LDI   LoaD  Indirect m[m[address]] into accumulator
    opSTI = (0xB, "STA")            # STA   STore Indirect accumulator into m[m[address]]
    opReservedC = (0xC, "ILLEGAL")
    opReservedD = (0xD, "ILLEGAL")
    opHLT = (0xE, "HLT")            # HLT   HaLT  processor

proc alu(a, b: int; op: OpCode): int =
  case op
  of opADD:
    return a + b
  of opSUB:
    return a - b
  of opXOR:
    return a xor b
  of opLDA:
    return b
  else:
    return 0

proc initMem(filename: string; mPtr: ptr Mem) =
  ## Initialize the memory (local and/or shared) by reading data from
  ## filename. The format is a simple form used by $readmemh()
  var
    address = 0
    data: int

  for line in lines(filename):
    if scanf(line, "@$h", address): # Set address
      continue
    elif scanf(line ,"$h", data): # Load address
      if address < memSize:
        mPtr[][address] = data
      else:
        C_init_mem(address, data)
      inc address

proc read(memPtr: ptr Mem; index: int; dataPtr: ptr int) =
  if index < memSize:
    discard V_posedge()
    dataPtr[] = memPtr[][index]
  else:
    discard V_read(index, dataPtr)

proc write(memPtr: ptr Mem; index: int; data: int) =
  if index < memSize:
    discard V_posedge()
    memPtr[][index] = data
  else:
    discard V_write(index, data)

proc C_risc(id: int): int {.exportc, dynlib.} =
  var
    mem: Mem
    acc = 0      # Accumulator
    pc = 0       # Program Counter
    pcs = pc     # Program Counter Save for debug
    tmp: int     # Temporary Memory Data
    ir: int
    op: OpCode
    maddr: int  # Memory address register

  let
    memPtr = cast[ptr Mem](addr mem[0])

  initMem(&"orig/pgm/pgm32.dat.{id}", memPtr)

  while true:
    pcs = pc
    read(memPtr, pc, addr ir)
    #---------------------------------------
    #| op   |         maddr                |
    #---------------------------------------
    # 31 28  27                           0
    op = OpCode(0xF and (ir shr 28))
    maddr = 0x0FFFFFFF and ir
    inc pc

    case op
    of opHLT:
      io_printf &"CPU {id} Halted at PC = {pcs.toHex(8)}, ACC = {acc.toHex(8)}\n"
      return 0
    of opSKZ:
      if acc == 0:
        inc pc
    of opJMI:
      read(memPtr, maddr, addr maddr)
    of opJMP:
      pc = maddr
    of opJSR:
      write(memPtr, maddr, pc)
      pc = maddr + 1
    of opSTI:
      read(memPtr, maddr, addr maddr)
    of opSTA:
      write(memPtr, maddr, acc)
    of opLDI:
      read(memPtr, maddr, addr maddr)
    of opADD, opSUB, opXOR, opLDA:
      read(memPtr, maddr, addr tmp)
      acc = alu(acc, tmp, op)
    else:
      io_printf &"CPU {id} bad opcode, PC = {pcs.toHex(8)}, IR = {ir.toHex(8)}\n"
      return 0
    io_printf &"CPU: {id} {op:<5} PC:{pcs.toHex(8)} IR:{ir.toHex(8)} ACC:{acc.toHex(8)}\n"
