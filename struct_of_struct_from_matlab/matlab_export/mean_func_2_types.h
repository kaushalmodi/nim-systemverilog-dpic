/*
 * File: mean_func_2_types.h
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 05-Apr-2019 11:33:15
 */

#ifndef MEAN_FUNC_2_TYPES_H
#define MEAN_FUNC_2_TYPES_H

/* Include Files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  int data[10];
  int len;
} struct0_T;

#endif                                 /*typedef_struct0_T*/

#ifndef typedef_struct2_T
#define typedef_struct2_T

typedef struct {
  double mean;
  int max;
  int min;
} struct2_T;

#endif                                 /*typedef_struct2_T*/

#ifndef typedef_struct1_T
#define typedef_struct1_T

typedef struct {
  struct2_T x1;
  struct2_T x2;
  struct2_T x3;
} struct1_T;

#endif                                 /*typedef_struct1_T*/
#endif

/*
 * File trailer for mean_func_2_types.h
 *
 * [EOF]
 */
