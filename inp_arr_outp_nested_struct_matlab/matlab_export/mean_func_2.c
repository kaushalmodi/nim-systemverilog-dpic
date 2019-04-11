/*
 * File: mean_func_2.c
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 05-Apr-2019 11:33:15
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "mean_func_2.h"

/* Function Definitions */

/*
 * Arguments    : const struct0_T in[3]
 *                struct1_T *out
 * Return Type  : void
 */
void mean_func_2(const struct0_T in[3], struct1_T *out)
{
  int j;
  int n;
  double y;
  int k;
  int ix;
  int mtmp;
  out->x1.mean = 0.0;
  out->x1.max = 0;
  out->x1.min = 0;
  out->x2.mean = 0.0;
  out->x2.max = 0;
  out->x2.min = 0;
  out->x3.mean = 0.0;
  out->x3.max = 0;
  out->x3.min = 0;
  for (j = 0; j < 3; j++) {
    if (1 > in[j].len) {
      n = 0;
    } else {
      n = in[j].len;
    }

    if (n == 0) {
      y = 0.0;
    } else {
      y = in[j].data[0];
      for (k = 2; k <= n; k++) {
        y += (double)in[j].data[k - 1];
      }
    }

    y /= (double)n;
    if (1 > in[j].len) {
      n = 0;
    } else {
      n = in[j].len;
    }

    k = in[j].data[0];
    if (n > 1) {
      for (ix = 1; ix + 1 <= n; ix++) {
        if (in[j].data[ix] > k) {
          k = in[j].data[ix];
        }
      }
    }

    if (1 > in[j].len) {
      n = 0;
    } else {
      n = in[j].len;
    }

    mtmp = in[j].data[0];
    if (n > 1) {
      for (ix = 1; ix + 1 <= n; ix++) {
        if (in[j].data[ix] < mtmp) {
          mtmp = in[j].data[ix];
        }
      }
    }

    if (1 + j == 1) {
      out->x1.mean = y;
      out->x1.max = k;
      out->x1.min = mtmp;
    } else if (1 + j == 2) {
      out->x2.mean = y;
      out->x2.max = k;
      out->x2.min = mtmp;
    } else {
      out->x3.mean = y;
      out->x3.max = k;
      out->x3.min = mtmp;
    }
  }
}

/*
 * File trailer for mean_func_2.c
 *
 * [EOF]
 */
