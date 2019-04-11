/*
 * File: mean_func_3_emxutil.h
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 10-Apr-2019 19:24:26
 */

#ifndef MEAN_FUNC_3_EMXUTIL_H
#define MEAN_FUNC_3_EMXUTIL_H

/* Include Files */
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rtwtypes.h"
#include "mean_func_3_types.h"

/* Function Declarations */
#ifdef __cplusplus

extern "C" {

#endif

  extern void emxEnsureCapacity_int32_T(emxArray_int32_T *emxArray, int oldNumel);
  extern void emxFreeStruct_in_struct_t(in_struct_t *pStruct);
  extern void emxFree_int32_T(emxArray_int32_T **pEmxArray);
  extern void emxInitStruct_in_struct_t(in_struct_t *pStruct);
  extern void emxInit_int32_T(emxArray_int32_T **pEmxArray, int numDimensions);

#ifdef __cplusplus

}
#endif
#endif

/*
 * File trailer for mean_func_3_emxutil.h
 *
 * [EOF]
 */
