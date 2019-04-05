/*
 * File: mean_func_1_emxAPI.c
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 04-Apr-2019 17:07:05
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "mean_func_1.h"
#include "mean_func_1_emxAPI.h"
#include "mean_func_1_emxutil.h"

/* Function Definitions */

/*
 * Arguments    : int numDimensions
 *                int *size
 * Return Type  : emxArray_int32_T *
 */
emxArray_int32_T *emxCreateND_int32_T(int numDimensions, int *size)
{
  emxArray_int32_T *emx;
  int numEl;
  int i;
  emxInit_int32_T(&emx, numDimensions);
  numEl = 1;
  for (i = 0; i < numDimensions; i++) {
    numEl *= size[i];
    emx->size[i] = size[i];
  }

  emx->data = (int *)calloc((unsigned int)numEl, sizeof(int));
  emx->numDimensions = numDimensions;
  emx->allocatedSize = numEl;
  return emx;
}

/*
 * Arguments    : int *data
 *                int numDimensions
 *                int *size
 * Return Type  : emxArray_int32_T *
 */
emxArray_int32_T *emxCreateWrapperND_int32_T(int *data, int numDimensions, int
  *size)
{
  emxArray_int32_T *emx;
  int numEl;
  int i;
  emxInit_int32_T(&emx, numDimensions);
  numEl = 1;
  for (i = 0; i < numDimensions; i++) {
    numEl *= size[i];
    emx->size[i] = size[i];
  }

  emx->data = data;
  emx->numDimensions = numDimensions;
  emx->allocatedSize = numEl;
  emx->canFreeData = false;
  return emx;
}

/*
 * Arguments    : int *data
 *                int rows
 *                int cols
 * Return Type  : emxArray_int32_T *
 */
emxArray_int32_T *emxCreateWrapper_int32_T(int *data, int rows, int cols)
{
  emxArray_int32_T *emx;
  int size[2];
  int numEl;
  int i;
  size[0] = rows;
  size[1] = cols;
  emxInit_int32_T(&emx, 2);
  numEl = 1;
  for (i = 0; i < 2; i++) {
    numEl *= size[i];
    emx->size[i] = size[i];
  }

  emx->data = data;
  emx->numDimensions = 2;
  emx->allocatedSize = numEl;
  emx->canFreeData = false;
  return emx;
}

/*
 * Arguments    : int rows
 *                int cols
 * Return Type  : emxArray_int32_T *
 */
emxArray_int32_T *emxCreate_int32_T(int rows, int cols)
{
  emxArray_int32_T *emx;
  int size[2];
  int numEl;
  int i;
  size[0] = rows;
  size[1] = cols;
  emxInit_int32_T(&emx, 2);
  numEl = 1;
  for (i = 0; i < 2; i++) {
    numEl *= size[i];
    emx->size[i] = size[i];
  }

  emx->data = (int *)calloc((unsigned int)numEl, sizeof(int));
  emx->numDimensions = 2;
  emx->allocatedSize = numEl;
  return emx;
}

/*
 * Arguments    : emxArray_int32_T *emxArray
 * Return Type  : void
 */
void emxDestroyArray_int32_T(emxArray_int32_T *emxArray)
{
  emxFree_int32_T(&emxArray);
}

/*
 * Arguments    : struct0_T emxArray
 * Return Type  : void
 */
void emxDestroy_struct0_T(struct0_T emxArray)
{
  emxFreeStruct_struct0_T(&emxArray);
}

/*
 * Arguments    : struct0_T *pStruct
 * Return Type  : void
 */
void emxInit_struct0_T(struct0_T *pStruct)
{
  emxInitStruct_struct0_T(pStruct);
}

/*
 * File trailer for mean_func_1_emxAPI.c
 *
 * [EOF]
 */
