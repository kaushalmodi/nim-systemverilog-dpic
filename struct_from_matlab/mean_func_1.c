/*
 * File: mean_func_1.c
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 04-Apr-2019 17:07:05
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "mean_func_1.h"
#include <stdio.h>

/* Function Definitions */

/*
 * Arguments    : const struct0_T *in
 *                struct1_T *out
 * Return Type  : void
 */
void mean_func_1(const struct0_T *in, struct1_T *out)
{
  int i;
  double y;
  int k;
  int ix;
  for (i = 1; i <= in->len; i++) {
    printf("in(%0d) = %0d;\n", i, in->data->data[i - 1]);
    fflush(stdout);
  }

  if (1 > in->len) {
    i = 0;
  } else {
    i = in->len;
  }

  if (i == 0) {
    y = 0.0;
  } else {
    y = in->data->data[0];
    for (k = 2; k <= i; k++) {
      y += (double)in->data->data[k - 1];
    }
  }

  out->mean = y / (double)i;
  if (1 > in->len) {
    i = 0;
  } else {
    i = in->len;
  }

  k = in->data->data[0];
  if (i > 1) {
    for (ix = 1; ix + 1 <= i; ix++) {
      if (in->data->data[ix] > k) {
        k = in->data->data[ix];
      }
    }
  }

  out->max = k;
  if (1 > in->len) {
    i = 0;
  } else {
    i = in->len;
  }

  k = in->data->data[0];
  if (i > 1) {
    for (ix = 1; ix + 1 <= i; ix++) {
      if (in->data->data[ix] < k) {
        k = in->data->data[ix];
      }
    }
  }

  out->min = k;
}

/*
 * File trailer for mean_func_1.c
 *
 * [EOF]
 */
