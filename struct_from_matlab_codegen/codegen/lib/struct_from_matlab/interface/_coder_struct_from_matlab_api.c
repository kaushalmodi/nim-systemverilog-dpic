/*
 * File: _coder_struct_from_matlab_api.c
 *
 * MATLAB Coder version            : 4.3
 * C/C++ source code generated on  : 29-Feb-2020 02:51:45
 */

/* Include Files */
#include "_coder_struct_from_matlab_api.h"
#include "_coder_struct_from_matlab_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131483U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "struct_from_matlab",                /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

/* Function Declarations */
static const mxArray *emlrt_marshallOut(const emlrtStack *sp, const myStruct *u);

/* Function Definitions */

/*
 * Arguments    : const emlrtStack *sp
 *                const myStruct *u
 * Return Type  : const mxArray *
 */
static const mxArray *emlrt_marshallOut(const emlrtStack *sp, const myStruct *u)
{
  const mxArray *y;
  static const char * sv[5] = { "someInt16Arr", "someDouble", "someInt32Arr",
    "someFloat", "someStr" };

  const mxArray *b_y;
  const mxArray *m;
  static const int32_T iv[2] = { 1, 5 };

  int16_T *pData;
  int32_T loop_ub;
  int32_T i;
  static const int32_T iv1[2] = { 1, 10 };

  int32_T *b_pData;
  char_T u_data[3];
  const mxArray *c_y;
  int32_T iv2[2];
  const mxArray *m1;
  const mxArray *propValues[1];
  const char * propNames[1] = { "Value" };

  const char * propClasses[1] = { "coder.internal.string" };

  y = NULL;
  emlrtAssign(&y, emlrtCreateStructMatrix(1, 1, 5, sv));
  b_y = NULL;
  m = emlrtCreateNumericArray(2, iv, mxINT16_CLASS, mxREAL);
  pData = (int16_T *)emlrtMxGetData(m);
  loop_ub = 0;
  for (i = 0; i < 5; i++) {
    pData[loop_ub] = u->someInt16Arr[i];
    loop_ub++;
  }

  emlrtAssign(&b_y, m);
  emlrtSetFieldR2017b(y, 0, "someInt16Arr", b_y, 0);
  b_y = NULL;
  m = emlrtCreateDoubleScalar(u->someDouble);
  emlrtAssign(&b_y, m);
  emlrtSetFieldR2017b(y, 0, "someDouble", b_y, 1);
  b_y = NULL;
  m = emlrtCreateNumericArray(2, iv1, mxINT32_CLASS, mxREAL);
  b_pData = (int32_T *)emlrtMxGetData(m);
  loop_ub = 0;
  for (i = 0; i < 10; i++) {
    b_pData[loop_ub] = u->someInt32Arr[i];
    loop_ub++;
  }

  emlrtAssign(&b_y, m);
  emlrtSetFieldR2017b(y, 0, "someInt32Arr", b_y, 2);
  b_y = NULL;
  m = emlrtCreateNumericMatrix(1, 1, mxSINGLE_CLASS, mxREAL);
  *(real32_T *)emlrtMxGetData(m) = u->someFloat;
  emlrtAssign(&b_y, m);
  emlrtSetFieldR2017b(y, 0, "someFloat", b_y, 3);
  b_y = NULL;
  emlrtAssign(&b_y, emlrtCreateClassInstance("coder.internal.string"));
  m = NULL;
  loop_ub = u->someStr.Value.size[0] * u->someStr.Value.size[1];
  if (0 <= loop_ub - 1) {
    memcpy(&u_data[0], &u->someStr.Value.data[0], loop_ub * sizeof(char_T));
  }

  c_y = NULL;
  iv2[0] = u->someStr.Value.size[0];
  iv2[1] = u->someStr.Value.size[1];
  m1 = emlrtCreateCharArray(2, &iv2[0]);
  emlrtInitCharArrayR2013a(sp, u->someStr.Value.size[1], m1, &u_data[0]);
  emlrtAssign(&c_y, m1);
  emlrtAssign(&m, c_y);
  propValues[0] = m;
  emlrtSetAllProperties(sp, &b_y, 0, 1, propNames, propClasses, propValues);
  emlrtAssign(&b_y, emlrtConvertInstanceToRedirectSource(sp, b_y, 0,
    "coder.internal.string"));
  emlrtSetFieldR2017b(y, 0, "someStr", b_y, 4);
  return y;
}

/*
 * Arguments    : int32_T nlhs
 *                const mxArray *plhs[2]
 * Return Type  : void
 */
void struct_from_matlab_api(int32_T nlhs, const mxArray *plhs[2])
{
  myStruct x;
  myStruct y;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Invoke the target function */
  struct_from_matlab(&x, &y);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(&st, &x);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(&st, &y);
  }
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void struct_from_matlab_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  struct_from_matlab_xil_terminate();
  struct_from_matlab_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void struct_from_matlab_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void struct_from_matlab_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_struct_from_matlab_api.c
 *
 * [EOF]
 */
