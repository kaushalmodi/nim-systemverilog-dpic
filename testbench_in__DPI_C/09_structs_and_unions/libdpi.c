#include "svdpi.h"

typedef struct {int p; int q; int r} PkdStru;

void send_arr_packed_struct(const svOpenArrayHandle dyn_arr)
{
  int i;
  PkdStru Sele;
  printf("\n \n Array Left %d, Array Right %d \n\n", svLeft(dyn_arr,1), svRight(dyn_arr, 1) );
  for (i= svLeft(dyn_arr,1); i <= svRight(dyn_arr,1); i++) {
    Sele = *(PkdStru*)svGetArrElemPtr1(dyn_arr, i);
    /* Mon Jan 21 15:21:46 EST 2019 - kmodi

       This example in C confirms that SystemVerilog is sending the
       content of packed struct with elements in reverse order.

       SV: arr_data[0] = '{p = -2071669239, q = -1064739199, r = 303379748}
       SV: arr_data[1] = '{p = 1189058957, q = 112818957, r = -1309649309}
       SV: arr_data[2] = '{p = 15983361, q = -1992863214, r = -1295874971}
       SV: arr_data[3] = '{p = 512609597, q = 992211318, r = 114806029}
       SV: arr_data[4] = '{p = 2097015289, q = 1177417612, r = 1993627629}


        Array Left 0, Array Right 4

       C : 0 : [303379748, -1064739199, -2071669239]
       C : 1 : [-1309649309, 112818957, 1189058957]
       C : 2 : [-1295874971, -1992863214, 15983361]
       C : 3 : [114806029, 992211318, 512609597]
       C : 4 : [1993627629, 1177417612, 2097015289]

    */
    printf("C : %d : [%d, %d, %d]\n",i, Sele.p, Sele.q, Sele.r);
  }
  printf("\n\n");
}
