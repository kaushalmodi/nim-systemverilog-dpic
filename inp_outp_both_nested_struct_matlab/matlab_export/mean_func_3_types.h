/*
 * File: mean_func_3_types.h
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 10-Apr-2019 19:24:26
 */

#ifndef MEAN_FUNC_3_TYPES_H
#define MEAN_FUNC_3_TYPES_H

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

#ifndef typedef_elem_struct_t
#define typedef_elem_struct_t

typedef struct {
  emxArray_int32_T *data;
  int len;
} elem_struct_t;

#endif                                 /*typedef_elem_struct_t*/

#ifndef typedef_in_struct_t
#define typedef_in_struct_t

typedef struct {
  elem_struct_t x1;
  elem_struct_t x2;
  elem_struct_t x3;
} in_struct_t;

#endif                                 /*typedef_in_struct_t*/

#ifndef typedef_struct1_T
#define typedef_struct1_T

typedef struct {
  double mean;
  int max;
  int min;
} struct1_T;

#endif                                 /*typedef_struct1_T*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  struct1_T x1;
  struct1_T x2;
  struct1_T x3;
} struct0_T;

#endif                                 /*typedef_struct0_T*/
#endif

/*
 * File trailer for mean_func_3_types.h
 *
 * [EOF]
 */
