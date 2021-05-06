
/* -------------------------------------------------------------
    Copyright 2011 Mentor Graphics, Inc.
    All Rights Reserved Worldwide

    Licensed under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in
    compliance with the License.  You may obtain a copy of
    the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in
    writing, software distributed under the License is
    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
    CONDITIONS OF ANY KIND, either express or implied.  See
    the License for the specific language governing
    permissions and limitations under the License.
 -------------------------------------------------------------*/


#include <stdio.h>
#include "risc.h"
DPI_LINK_DECL void
V_init_memmm(
    int A,
    int D);

/* Local memory boundary */
#define LMEM 0x100

#define HLT 0xE
#define SKZ 0x1
#define ADD 0x2
#define SUB 0x3
#define XOR 0x4
#define LDA 0x5
#define STA 0x6
#define JMP 0x7
#define JSR 0x8
#define JMI 0x9
#define LDI 0xA
#define STI 0xB

/*  HLT   HaLT  processor */
/*  SKZ   SKip  if accumulator is Zero */
/*  ADD   ADD   m[address] to accumulator */
/*  SUB   SUB   m[address] with accumulator */
/*  XOR   XOR   m[address] with accumulator */
/*  LDA   LoaD  m[address] into Accumulator */
/*  STA   STore Accumulator into m[address] */
/*  JMP   JuMP  to address */
/*  JSR   JuMP  to Subroutine */
/*  JMI   JuMp  Indirect to m[address] */
/*  LDI   LoaD  Indirect m[m[address]] into accumulator */
/*  STA   STore Indirect accumulator into m[m[address]] */

/*  ------------------------------------- */
/*  |OP  |        ADDRESS               | */
/*  ------------------------------------- */
/*  31 28 27                            0 */


#define ADDR 0x0FFFFFFF & IR
#define OPCODE 0xF & (IR>>28)

char *MN[] = {"ILLEGAL","SKZ","ADD","SUB","XOR","LDA","STA","JMP","JSR","JMI","LDI","STI"};

int ALU (int A, int B, int OP) {

  switch (OP) {
  case ADD :
    return(A + B);
  case SUB :
    return(A - B);
  case XOR :
    return(A ^ B);
  case LDA :
    return(B);
  }
  return(0);
}

/* Initialize the memory (local and/or shared) by reading data from
   filename. The format is a simple form used by $readmemh()




 */

void Init(int *MEM,char *filename) {

  int address=0;
  int data;
  char line[256];

  FILE *fp; 
  fp = fopen(filename,"r");

  while (fgets(line,sizeof(line),fp) > 0) {
    if (sscanf(line,"@%x",&address) == 1)
      /*   set address */
      continue;
    else if (sscanf(line,"%x",&data) == 1) {
     /* load address */
      if (address < LMEM) {
	MEM[address] = data;
      } else {
	C_init_mem(address,data);
      }
      address++;
    }
  }
}

void Read(int *MEM,int index,int *data) {
  if (index < LMEM) {
    V_posedge();
    *data = MEM[index];
  } else {
    V_read(index,data);
  }
}
void Write(int *MEM,int index,int data) {
  if (index < LMEM) {
    V_posedge();
    MEM[index] = data;
  } else {
    V_write(index,data);
  }
}

extern int C_risc (int ID) {

  char *Filename = (char *) malloc(20);
  char *logFileName = (char *) malloc(20);

  int ACC = 0; /*  Accumulator */
  int PC = 0;  /*  Program Counter */
  int PCS = 0;  /*  Program Counter Save for debug */
  int TMP;     /*  Temporary Memory Data */
  int IR;
  int MADDR; /*  Memory address register */
  int MEM[LMEM];

  FILE *logPtr;

  sprintf(Filename,"pgm/pgm32.dat.%d",ID);

  sprintf(logFileName,"logs/cpu%0d.txt", ID);
  logPtr = fopen(logFileName,"w");

  Init(MEM, Filename);

  while(1) {
    PCS = PC;
    Read(MEM, PC++, &IR);
    MADDR = ADDR; /*  Latch address */
    switch (OPCODE) {
    case HLT :
      io_printf("CPU %d Halted at PC = %08x ACC = %08x\n", ID, PCS, ACC);
      fprintf(logPtr, "CPU %d Halted at PC = %08x ACC = %08x\n", ID, PCS, ACC);
      return 0;
      break;
    case SKZ : 
      if (ACC == 0)
	PC++;
      break;
    case JMI :
      Read(MEM,MADDR,&MADDR);
    case JMP :
      PC = MADDR;
      break;
    case JSR :
      Write(MEM, MADDR, PC);
      PC = MADDR+1;
      break;
    case STI :
      Read(MEM,MADDR,&MADDR);
    case STA :
      Write(MEM, MADDR, ACC);
      break;
    case LDI :
      Read(MEM,MADDR,&MADDR);
    case ADD :
    case SUB :
    case XOR :
    case LDA :
      Read(MEM, MADDR, &TMP);
      ACC = ALU(ACC, TMP, OPCODE);
      break;
    default :
      io_printf("CPU %d bad opcode PC = %X IR=%X\n", ID,PCS,IR);
      fprintf(logPtr, "CPU %d bad opcode PC = %X IR=%X\n", ID,PCS,IR);
      return 0;
      break;
    }
    io_printf("CPU: %d %s   PC:%08X IR:%08X ACC:%08X\n", ID,MN[OPCODE],PCS,IR,ACC);
    fprintf(logPtr, "CPU: %d %s   PC:%08X IR:%08X ACC:%08X\n", ID,MN[OPCODE],PCS,IR,ACC);
  }
}
