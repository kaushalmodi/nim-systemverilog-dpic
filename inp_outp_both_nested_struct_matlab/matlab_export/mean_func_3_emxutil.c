/*
 * File: mean_func_3_emxutil.c
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 10-Apr-2019 19:24:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "mean_func_3.h"
#include "mean_func_3_emxutil.h"

/* Function Declarations */
static void emxFreeStruct_elem_struct_t(elem_struct_t *pStruct);
static void emxInitStruct_elem_struct_t(elem_struct_t *pStruct);

/* Function Definitions */

/*
 * Arguments    : elem_struct_t *pStruct
 * Return Type  : void
 */
static void emxFreeStruct_elem_struct_t(elem_struct_t *pStruct)
{
  emxFree_int32_T(&pStruct->data);
}

/*
 * Arguments    : elem_struct_t *pStruct
 * Return Type  : void
 */
static void emxInitStruct_elem_struct_t(elem_struct_t *pStruct)
{
  emxInit_int32_T(&pStruct->data, 1);
}

/*
 * Arguments    : emxArray_int32_T *emxArray
 *                int oldNumel
 * Return Type  : void
 */
void emxEnsureCapacity_int32_T(emxArray_int32_T *emxArray, int oldNumel)
{
  int newNumel;
  int i;
  void *newData;
  if (oldNumel < 0) {
    oldNumel = 0;
  }

  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel *= emxArray->size[i];
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      if (i > 1073741823) {
        i = MAX_int32_T;
      } else {
        i <<= 1;
      }
    }

    newData = calloc((unsigned int)i, sizeof(int));
    if (emxArray->data != NULL) {
      memcpy(newData, (void *)emxArray->data, sizeof(int) * oldNumel);
      if (emxArray->canFreeData) {
        free((void *)emxArray->data);
      }
    }

    emxArray->data = (int *)newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

/*
 * Arguments    : in_struct_t *pStruct
 * Return Type  : void
 */
void emxFreeStruct_in_struct_t(in_struct_t *pStruct)
{
  emxFreeStruct_elem_struct_t(&pStruct->x1);
  emxFreeStruct_elem_struct_t(&pStruct->x2);
  emxFreeStruct_elem_struct_t(&pStruct->x3);
}

/*
 * Arguments    : emxArray_int32_T **pEmxArray
 * Return Type  : void
 */
void emxFree_int32_T(emxArray_int32_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_int32_T *)NULL) {
    if (((*pEmxArray)->data != (int *)NULL) && (*pEmxArray)->canFreeData) {
      free((void *)(*pEmxArray)->data);
    }

    free((void *)(*pEmxArray)->size);
    free((void *)*pEmxArray);
    *pEmxArray = (emxArray_int32_T *)NULL;
  }
}

/*
 * Arguments    : in_struct_t *pStruct
 * Return Type  : void
 */
void emxInitStruct_in_struct_t(in_struct_t *pStruct)
{
  emxInitStruct_elem_struct_t(&pStruct->x1);
  emxInitStruct_elem_struct_t(&pStruct->x2);
  emxInitStruct_elem_struct_t(&pStruct->x3);
}

/*
 * Arguments    : emxArray_int32_T **pEmxArray
 *                int numDimensions
 * Return Type  : void
 */
void emxInit_int32_T(emxArray_int32_T **pEmxArray, int numDimensions)
{
  emxArray_int32_T *emxArray;
  int i;
  *pEmxArray = (emxArray_int32_T *)malloc(sizeof(emxArray_int32_T));
  emxArray = *pEmxArray;
  emxArray->data = (int *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int *)malloc((unsigned int)(sizeof(int) * numDimensions));
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

/*
 * File trailer for mean_func_3_emxutil.c
 *
 * [EOF]
 */
