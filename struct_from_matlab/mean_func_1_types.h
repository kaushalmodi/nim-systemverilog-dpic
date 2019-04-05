/*
 * File: mean_func_1_types.h
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 04-Apr-2019 17:07:05
 */

#ifndef MEAN_FUNC_1_TYPES_H
#define MEAN_FUNC_1_TYPES_H

/* Include Files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef struct_emxArray_int32_T
#define struct_emxArray_int32_T

struct emxArray_int32_T
{
  int *data;
  int *size;
  int allocatedSize;
  int numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_int32_T*/

#ifndef typedef_emxArray_int32_T
#define typedef_emxArray_int32_T

typedef struct emxArray_int32_T emxArray_int32_T;

#endif                                 /*typedef_emxArray_int32_T*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  emxArray_int32_T *data;
  int len;
} struct0_T;

#endif                                 /*typedef_struct0_T*/

#ifndef typedef_struct1_T
#define typedef_struct1_T

typedef struct {
  double mean;
  int max;
  int min;
} struct1_T;

#endif                                 /*typedef_struct1_T*/
#endif

/*
 * File trailer for mean_func_1_types.h
 *
 * [EOF]
 */
