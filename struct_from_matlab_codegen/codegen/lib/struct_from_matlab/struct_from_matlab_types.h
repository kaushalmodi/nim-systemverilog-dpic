/*
 * File: struct_from_matlab_types.h
 *
 * MATLAB Coder version            : 4.3
 * C/C++ source code generated on  : 29-Feb-2020 02:51:45
 */

#ifndef STRUCT_FROM_MATLAB_TYPES_H
#define STRUCT_FROM_MATLAB_TYPES_H

/* Include Files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef struct_emxArray_char_T_1x3
#define struct_emxArray_char_T_1x3

struct emxArray_char_T_1x3
{
  char data[3];
  int size[2];
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
  short someInt16Arr[5];
  double someDouble;
  int someInt32Arr[10];
  float someFloat;
  rtString someStr;
};

#endif                                 /*struct_sjEr900CinMbZsmuk0E4kHE_tag*/

#ifndef typedef_myStruct
#define typedef_myStruct

typedef struct sjEr900CinMbZsmuk0E4kHE_tag myStruct;

#endif                                 /*typedef_myStruct*/
#endif

/*
 * File trailer for struct_from_matlab_types.h
 *
 * [EOF]
 */
