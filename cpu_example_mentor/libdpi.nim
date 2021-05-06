import std/[strformat, strscans, strutils]
import svdpi

## imported procs
proc V_posedge(): int {.importc, discardable.}
proc V_init_mem(index, data: int) {.importc.}
proc V_read(address: int; dataPtr: ptr int): int {.importc, discardable.}
proc V_write(address: int; data: int): int {.importc, discardable.}

proc io_printf(formatStr: cstring) {.importc, header: "veriuser.h", varargs.}

## procs
proc log(fPtr: File; msg: string ) =
  io_printf(msg & "\n")
  fPtr.writeLine(msg)

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
    V_posedge()

  while true:
    var
      flag = 0
      localA = Complex()
      localB = Complex()
      localX = Complex()

    while flag != dspBegin:
      V_read(dspFlag, addr flag)

    # Get A and B operands
    V_read(dspA, addr localA.re)
    V_read(dspA+1, addr localA.im)
    V_read(dspB, addr localB.re)
    V_read(dspB+1, addr localB.im)

    # Your algorithm here
    localX.re = (localA.re * localB.re) - (localA.im * localB.im)
    localX.im = (localA.re * localB.re) + (localA.im * localB.im)

    # Delay result by expected number of instructions
    for i in 0 ..< 2*localA.re:
      V_posedge()

    # Save result
    V_write(dspX, localX.re)
    V_write(dspX+1, localX.im)
    V_write(dspFlag, dspEnd)

## risc
const
  memSize = 0x100
  # alu output is 32-bits wide. Below create the mask as 0xffffffff.
  # But we cannot directly set that to 0xffffffff because that's
  # not an int, but an int64. So it won't be compatible with the
  # int types.
  aluMask = when sizeof(int) == 4: # 32-bit compilation
              -1
            else:
              from math import `^`
              (2^32) - 1

type
  Mem = array[memSize, int]
  OpCode = enum
    opIllegal = (0x0, "ILLEGAL")
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
    result = a + b
  of opSUB:
    result = a - b
  of opXOR:
    result = a xor b
  of opLDA:
    result = b
  else:
    result = 0
  result = result and aluMask

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
        withScope "system.m1":
          V_init_mem(address, data)
      inc address

proc read(memPtr: ptr Mem; index: int; dataPtr: ptr int) =
  if index < memSize:
    V_posedge()
    dataPtr[] = memPtr[][index]
  else:
    V_read(index, dataPtr)

proc write(memPtr: ptr Mem; index: int; data: int) =
  if index < memSize:
    V_posedge()
    memPtr[][index] = data
  else:
    V_write(index, data)

proc C_risc(id: int): int {.exportc, dynlib.} =
  var
    mem: Mem
    acc = 0      # Accumulator
    pc = 0       # Program Counter
    ir: int
    maddr: int  # Memory address register

  let
    memPtr = cast[ptr Mem](addr mem[0])
    logFileName = &"logs/cpu{id}.txt"
    fPtr = open(logFileName, fmWrite)

  initMem(&"pgm/pgm32.dat.{id}", memPtr)

  while true:
    let
      pcs = pc     # Program Counter Save for debug
    read(memPtr, pc, addr ir)
    inc pc
    #---------------------------------------
    #| op   |         maddr                |
    #---------------------------------------
    # 31 28  27                           0
    maddr = 0x0FFFFFFF and ir # Latch address

    let
      op = OpCode(0xF and (ir shr 28))

    case op
    of opHLT:
      fPtr.log &"CPU {id} Halted at PC = {pcs.toHex(8)} ACC = {acc.toHex(8)}"
      return 0
    of opSKZ:
      # fPtr.log &"SKZ: ACC = {acc} | {acc.toHex(8)}, PC = {pc.toHex(8)}"
      if acc == 0:
        inc pc
    of opJMI, opJMP:
      if op in {opJMI}:
        read(memPtr, maddr, addr maddr)
      pc = maddr
    of opJSR:
      write(memPtr, maddr, pc)
      pc = maddr + 1
    of opSTI, opSTA:
      if op in {opSTI}:
        read(memPtr, maddr, addr maddr)
      write(memPtr, maddr, acc)
    of opLDI, opADD, opSUB, opXOR, opLDA:
      if op in {opLDI}:
        read(memPtr, maddr, addr maddr)
      var
        tmp: int     # Temporary Memory Data
      read(memPtr, maddr, addr tmp)
      acc = alu(acc, tmp, op)
    else:
      fPtr.log &"CPU {id} bad opcode ({op.int}) PC = {pcs.toHex(8)} IR = {ir.toHex(8)}"
      return 0
    fPtr.log &"CPU: {id} {op:<5} PC:{pcs.toHex(8)} IR:{ir.toHex(8)} ACC:{acc.toHex(8)}"
