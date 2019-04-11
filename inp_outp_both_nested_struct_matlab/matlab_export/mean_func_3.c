/*
 * File: mean_func_3.c
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 10-Apr-2019 19:24:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "mean_func_3.h"
#include "mean_func_3_emxutil.h"

/* Function Definitions */

/*
 * Arguments    : const in_struct_t *in
 *                struct0_T *out
 * Return Type  : void
 */
void mean_func_3(const in_struct_t *in, struct0_T *out)
{
  emxArray_int32_T *data;
  int j;
  int n;
  int loop_ub;
  int len;
  double y;
  int mtmp;
  int ix;
  out->x1.mean = 0.0;
  out->x1.max = 0;
  out->x1.min = 0;
  out->x2.mean = 0.0;
  out->x2.max = 0;
  out->x2.min = 0;
  out->x3.mean = 0.0;
  out->x3.max = 0;
  out->x3.min = 0;
  emxInit_int32_T(&data, 1);
  for (j = 0; j < 3; j++) {
    if (1 + j == 1) {
      n = data->size[0];
      data->size[0] = in->x1.data->size[0];
      emxEnsureCapacity_int32_T(data, n);
      loop_ub = in->x1.data->size[0];
      for (n = 0; n < loop_ub; n++) {
        data->data[n] = in->x1.data->data[n];
      }

      len = in->x1.len;
    } else if (1 + j == 2) {
      n = data->size[0];
      data->size[0] = in->x2.data->size[0];
      emxEnsureCapacity_int32_T(data, n);
      loop_ub = in->x2.data->size[0];
      for (n = 0; n < loop_ub; n++) {
        data->data[n] = in->x2.data->data[n];
      }

      len = in->x2.len;
    } else {
      n = data->size[0];
      data->size[0] = in->x3.data->size[0];
      emxEnsureCapacity_int32_T(data, n);
      loop_ub = in->x3.data->size[0];
      for (n = 0; n < loop_ub; n++) {
        data->data[n] = in->x3.data->data[n];
      }

      len = in->x3.len;
    }

    if (1 > len) {
      n = 0;
    } else {
      n = len;
    }

    if (n == 0) {
      y = 0.0;
    } else {
      y = data->data[0];
      for (loop_ub = 2; loop_ub <= n; loop_ub++) {
        y += (double)data->data[loop_ub - 1];
      }
    }

    y /= (double)n;
    if (1 > len) {
      n = 0;
    } else {
      n = len;
    }

    mtmp = data->data[0];
    if (n > 1) {
      for (ix = 1; ix + 1 <= n; ix++) {
        if (data->data[ix] > mtmp) {
          mtmp = data->data[ix];
        }
      }
    }

    if (1 > len) {
      n = 0;
    } else {
      n = len;
    }

    loop_ub = data->data[0];
    if (n > 1) {
      for (ix = 1; ix + 1 <= n; ix++) {
        if (data->data[ix] < loop_ub) {
          loop_ub = data->data[ix];
        }
      }
    }

    if (1 + j == 1) {
      out->x1.mean = y;
      out->x1.max = mtmp;
      out->x1.min = loop_ub;
    } else if (1 + j == 2) {
      out->x2.mean = y;
      out->x2.max = mtmp;
      out->x2.min = loop_ub;
    } else {
      out->x3.mean = y;
      out->x3.max = mtmp;
      out->x3.min = loop_ub;
    }
  }

  emxFree_int32_T(&data);
}

/*
 * File trailer for mean_func_3.c
 *
 * [EOF]
 */
