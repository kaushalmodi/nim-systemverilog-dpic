/*
 * File: _coder_struct_from_matlab_mex.c
 *
 * MATLAB Coder version            : 4.3
 * C/C++ source code generated on  : 29-Feb-2020 02:51:45
 */

/* Include Files */
#include "_coder_struct_from_matlab_mex.h"
#include "_coder_struct_from_matlab_api.h"

/* Function Declarations */
MEXFUNCTION_LINKAGE void struct_from_matlab_mexFunction(int32_T nlhs, mxArray
  *plhs[2], int32_T nrhs);

/* Function Definitions */

/*
 * Arguments    : int32_T nlhs
 *                mxArray *plhs[2]
 *                int32_T nrhs
 * Return Type  : void
 */
void struct_from_matlab_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T nrhs)
{
  const mxArray *outputs[2];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 0) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 0, 4,
                        18, "struct_from_matlab");
  }

  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 18,
                        "struct_from_matlab");
  }

  /* Call the function. */
  struct_from_matlab_api(nlhs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);
}

/*
 * Arguments    : int32_T nlhs
 *                mxArray *plhs[]
 *                int32_T nrhs
 *                const mxArray *prhs[]
 * Return Type  : void
 */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  (void)prhs;
  mexAtExit(struct_from_matlab_atexit);

  /* Module initialization. */
  struct_from_matlab_initialize();

  /* Dispatch the entry-point. */
  struct_from_matlab_mexFunction(nlhs, plhs, nrhs);

  /* Module termination. */
  struct_from_matlab_terminate();
}

/*
 * Arguments    : void
 * Return Type  : emlrtCTX
 */
emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/*
 * File trailer for _coder_struct_from_matlab_mex.c
 *
 * [EOF]
 */
