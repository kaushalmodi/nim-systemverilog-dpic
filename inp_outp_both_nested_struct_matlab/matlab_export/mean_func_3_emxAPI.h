/*
 * File: mean_func_3_emxAPI.h
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 10-Apr-2019 19:24:26
 */

#ifndef MEAN_FUNC_3_EMXAPI_H
#define MEAN_FUNC_3_EMXAPI_H

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

  extern emxArray_int32_T *emxCreateND_int32_T(int numDimensions, int *size);
  extern emxArray_int32_T *emxCreateWrapperND_int32_T(int *data, int
    numDimensions, int *size);
  extern emxArray_int32_T *emxCreateWrapper_int32_T(int *data, int rows, int
    cols);
  extern emxArray_int32_T *emxCreate_int32_T(int rows, int cols);
  extern void emxDestroyArray_int32_T(emxArray_int32_T *emxArray);
  extern void emxDestroy_in_struct_t(in_struct_t emxArray);
  extern void emxInit_in_struct_t(in_struct_t *pStruct);

#ifdef __cplusplus

}
#endif
#endif

/*
 * File trailer for mean_func_3_emxAPI.h
 *
 * [EOF]
 */
