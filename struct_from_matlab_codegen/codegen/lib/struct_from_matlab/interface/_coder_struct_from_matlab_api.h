/*
 * File: _coder_struct_from_matlab_api.h
 *
 * MATLAB Coder version            : 4.3
 * C/C++ source code generated on  : 29-Feb-2020 02:51:45
 */

#ifndef _CODER_STRUCT_FROM_MATLAB_API_H
#define _CODER_STRUCT_FROM_MATLAB_API_H

/* Include Files */
#include <stddef.h>
#include <stdlib.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Type Definitions */
#ifndef struct_emxArray_char_T_1x3
#define struct_emxArray_char_T_1x3

struct emxArray_char_T_1x3
{
  char_T data[3];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_char_T_1x3*/

#ifndef typedef_emxArray_char_T_1x3
#define typedef_emxArray_char_T_1x3

typedef struct emxArray_char_T_1x3 emxArray_char_T_1x3;

#endif                                 /*typedef_emxArray_char_T_1x3*/

#ifndef struct_sC0ohWpyf2aUOY4jn8s2wNH_tag
#define struct_sC0ohWpyf2aUOY4jn8s2wNH_tag

struct sC0ohWpyf2aUOY4jn8s2wNH_tag
{
  emxArray_char_T_1x3 Value;
};

#endif                                 /*struct_sC0ohWpyf2aUOY4jn8s2wNH_tag*/

#ifndef typedef_rtString
#define typedef_rtString

typedef struct sC0ohWpyf2aUOY4jn8s2wNH_tag rtString;

#endif                                 /*typedef_rtString*/

#ifndef struct_sjEr900CinMbZsmuk0E4kHE_tag
#define struct_sjEr900CinMbZsmuk0E4kHE_tag

struct sjEr900CinMbZsmuk0E4kHE_tag
{
  int16_T someInt16Arr[5];
  real_T someDouble;
  int32_T someInt32Arr[10];
  real32_T someFloat;
  rtString someStr;
};

#endif                                 /*struct_sjEr900CinMbZsmuk0E4kHE_tag*/

#ifndef typedef_myStruct
#define typedef_myStruct

typedef struct sjEr900CinMbZsmuk0E4kHE_tag myStruct;

#endif                                 /*typedef_myStruct*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void struct_from_matlab(myStruct *x, myStruct *y);
extern void struct_from_matlab_api(int32_T nlhs, const mxArray *plhs[2]);
extern void struct_from_matlab_atexit(void);
extern void struct_from_matlab_initialize(void);
extern void struct_from_matlab_terminate(void);
extern void struct_from_matlab_xil_shutdown(void);
extern void struct_from_matlab_xil_terminate(void);

#endif

/*
 * File trailer for _coder_struct_from_matlab_api.h
 *
 * [EOF]
 */
