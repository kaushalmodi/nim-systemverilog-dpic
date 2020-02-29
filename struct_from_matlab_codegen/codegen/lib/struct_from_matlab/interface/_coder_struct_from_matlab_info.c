/*
 * File: _coder_struct_from_matlab_info.c
 *
 * MATLAB Coder version            : 4.3
 * C/C++ source code generated on  : 29-Feb-2020 02:51:45
 */

/* Include Files */
#include "_coder_struct_from_matlab_info.h"
#include "emlrt.h"
#include "tmwtypes.h"

/* Function Declarations */
static const mxArray *emlrtMexFcnResolvedFunctionsInfo(void);

/* Function Definitions */

/*
 * Arguments    : void
 * Return Type  : const mxArray *
 */
static const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  const mxArray *nameCaptureInfo;
  const char * data[9] = {
    "789ced594b73124b186dacf8c84265a32bab2e2e6f5966925846dd994c6298bc2440b8c454947934d061a61be60198cdcd3fb8eef467b8d49d2bcb850b577aeb"
    "fe9a3bcfc08c763161460264ba8acc7c9c9a3edff7357d3874408adb4e01006e98afddbf0178b708ec71ddb980b47bbd04fc2388a7dceb6c20f6c66530e37b2e",
    "e5f2fde3c622c13aecea4e8079059e3e291105611eebc5d74d0854a811b90d251ba92219169102b7485f904566a03ceb834e030bb2eed93a141b0543016a5deb"
    "6528f707763facf18552ef4cc87e88947ea403f801b755660f199197185e420cdf6c6a8cc2ebf50e511bf69dcc0bcce2fcc21381d1099105d265b43aaf428911",
    "890455f7af8c04e69e737b0f990d55312f339aae225c9b537c759d44ac2b33a02e0fb79399535017e1392fa3b94293906a1e3689aa7bf95422e673959a8f8318"
    "b88149079fd6ff2d221fa6f2f9f1032ee665b55bd9b7ba7dbdb49678503faf84ac2f78f5c62cb8e6dd7e7e7bf7c7f208f9ec7151f8ba94f9c27e3e6f53f8d201",
    "7c6d6795dbdeec36e78df58576adb4da6ebd5814d67b79e406f00cca0350e251cd5fa13c3fa88fc141eb6390ef64483e6ffe3f06f079b8a3aba78aca6905a418"
    "32c28d82adf6e756ffa721f9bcf95f0ee0f3f021be2fa122dbaf9fbe2083cd1bad8e9ea43efef73dd1d1dfc4372a1ddd28ad2cb78b9cbe71cc1d2d3f6bd6361f",
    "eeeabbd9e9d1d1f794e7c3f67183327f3a801fac1d3275a240a6a110735f6b3c96acbdeb6e68b106b1e5670d517f555589f2ca7dffe7b75cbb1bdbe7e0d680fc"
    "3d3ca0cb8ef706d1bf8f86f5b9d3fafba542c93b3e1d79fad7d77ce26f275d97f7d96ab906d915a35c5d5a16786e5738e64436d1e571d1e54ac4fcaf04e25efe",
    "0ee209705c7c3381b8c7e720a2296ad6d5e37b1391ef4f2a9f1f3f28b32b874eb119a465f88c602059bf8f7046817a9d487e15bd383a33ed7ca3d2d1bd173ba5"
    "a5f5c2ead14eb6b577547b9de31fe4c4293a2718f77d3ae9fe3538c29e2724fef5d77525fef57cf912ff1acffc176d7f87adeb5a20eed5e52048d39abcaac1f3",
    "f2b51f22f215a97c7edc5ab7b5b39ff35a0be5fd0631fb543530e375cc59a8119eef6ecdde497478d275b8c5927c6e4998cf3fce6ee7a5f97ae991211757131d"
    "1e771d4e7cf3d9f8c67d3d2b94bc13df3c197c896f8e67fe7f29cf87ed638b327f3a800fe1bfcebabfef62a22abc8c8e21eb9a4c109f8fbe4cadd34190a6924e",
    "8c7c67f5d151cfef9f53f9fc78741f0d65f386b1fb656af208fdf325f966a2c7e3aac761fdd15ef5a1803759d229e7c876abfe6841638f34303d7a3cadfb38be"
    "f30a935545dd493dafc853f9fc787cebe3f42becff4b63f4bf89defe46be51f9df6eadbd96dbdfcf75584d286505a2c027c2cecae4ebedffca963d23",
    "" };

  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(&data[0], 12976U, &nameCaptureInfo);
  return nameCaptureInfo;
}

/*
 * Arguments    : void
 * Return Type  : mxArray *
 */
mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xResult;
  mxArray *xEntryPoints;
  const char * epFieldName[6] = { "Name", "NumberOfInputs", "NumberOfOutputs",
    "ConstantInputs", "FullPath", "TimeStamp" };

  mxArray *xInputs;
  const char * propFieldName[4] = { "Version", "ResolvedFunctions",
    "EntryPoints", "CoverageInfo" };

  xEntryPoints = emlrtCreateStructMatrix(1, 1, 6, epFieldName);
  xInputs = emlrtCreateLogicalMatrix(1, 0);
  emlrtSetField(xEntryPoints, 0, "Name", emlrtMxCreateString(
    "struct_from_matlab"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs", emlrtMxCreateDoubleScalar(0.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs", emlrtMxCreateDoubleScalar
                (2.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  emlrtSetField(xEntryPoints, 0, "FullPath", emlrtMxCreateString(
    "/home/kmodi/sandbox/matlab/cgen/struct_from_matlab/struct_from_matlab.m"));
  emlrtSetField(xEntryPoints, 0, "TimeStamp", emlrtMxCreateDoubleScalar
                (737850.11840277782));
  xResult = emlrtCreateStructMatrix(1, 1, 4, propFieldName);
  emlrtSetField(xResult, 0, "Version", emlrtMxCreateString(
    "9.7.0.1216025 (R2019b) Update 1"));
  emlrtSetField(xResult, 0, "ResolvedFunctions", (mxArray *)
                emlrtMexFcnResolvedFunctionsInfo());
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  return xResult;
}

/*
 * File trailer for _coder_struct_from_matlab_info.c
 *
 * [EOF]
 */
