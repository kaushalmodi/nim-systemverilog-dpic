#include <stdio.h>
#include "risc.h"

#define DSP_begin 1
#define DSP_end -1
#define DSP_flag 0x210
#define DSP_A  0x211
#define DSP_B  0x213
#define DSP_X  0x215

typedef struct {
                int r;
                int i;
                } complex;

extern int C_dsp (int ID) {
  int i;
  // Wait for initialization
  for(i=0;i<10;i++) {
    V_posedge();
  }
  while(1) {
    int flag = 0;
    complex Local_A;
    complex Local_B;
    complex Local_X;
    while (flag != DSP_begin) {
      V_read(DSP_flag, &flag);
	}
    // Get A and B operands
    V_read(DSP_A, &Local_A.r);
    V_read(DSP_A+1, &Local_A.i);
    V_read(DSP_B, &Local_B.r);
    V_read(DSP_B+1, &Local_B.i);

    // your algorithm here
    Local_X.r = (Local_A.r * Local_B.r) - (Local_A.i * Local_B.i);
    Local_X.i = (Local_A.r * Local_B.r) + (Local_A.i * Local_B.i);
 
    // Delay result by expected number of instructions
    for(i=0;i<2*Local_A.r;i++) {
      V_posedge();
    }
    // Save result
    V_write(DSP_X,Local_X.r);
    V_write(DSP_X+1,Local_X.i);
    V_write(DSP_flag,DSP_end);
  }
}







