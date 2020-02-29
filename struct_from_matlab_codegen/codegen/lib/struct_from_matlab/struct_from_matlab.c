/*
 * File: struct_from_matlab.c
 *
 * MATLAB Coder version            : 4.3
 * C/C++ source code generated on  : 29-Feb-2020 02:51:45
 */

/* Include Files */
#include "struct_from_matlab.h"

/* Function Definitions */

/*
 * Below is a hack.. assign 'struct' output to a variable and use that variable as a "type".
 *  % short someInt16Arr[5]
 *  % double someDouble
 *  % int someInt32Arr[10]
 *  % float someFloat
 *  % rtString someStr
 * Arguments    : myStruct *x
 *                myStruct *y
 * Return Type  : void
 */
void struct_from_matlab(myStruct *x, myStruct *y)
{
  int i;

  /*  Example of defining C-export-friendly "types" */
  /*  - Run codegen -config:lib -c struct_from_matlab */
  /*  - The .c and .h files will be created in ./codegen/lib/struct_from_matlab/ */
  for (i = 0; i < 5; i++) {
    x->someInt16Arr[i] = 0;
  }

  x->someDouble = 0.0;
  for (i = 0; i < 10; i++) {
    x->someInt32Arr[i] = 0;
  }

  x->someFloat = 0.0F;
  x->someStr.Value.size[0] = 1;
  x->someStr.Value.size[1] = 0;

  /*  Now define the struct name you'd like to see in the C Header. */
  /*  Pseudo declaration of vars x and y to "type" myStruct. */
  *y = *x;

  /*  Assigning values to the x and y elements in arbitrary order. */
  x->someStr.Value.size[0] = 1;
  x->someStr.Value.size[1] = 3;
  x->someFloat = 7.9F;
  x->someInt32Arr[7] = 200;
  x->someInt16Arr[4] = 300;
  x->someDouble = 1.3;
  y->someInt32Arr[0] = 100;
  y->someStr.Value.size[0] = 1;
  y->someStr.Value.size[1] = 3;
  x->someStr.Value.data[0] = 'a';
  y->someStr.Value.data[0] = 'd';
  x->someStr.Value.data[1] = 'b';
  y->someStr.Value.data[1] = 'e';
  x->someStr.Value.data[2] = 'c';
  y->someStr.Value.data[2] = 'f';
  y->someFloat = 4.4F;

  /*  References */
  /*  https://www.mathworks.com/help/simulink/slref/coder.cstructname.html */
  /*  https://www.mathworks.com/help/matlab/data-types.html */
}

/*
 * File trailer for struct_from_matlab.c
 *
 * [EOF]
 */
