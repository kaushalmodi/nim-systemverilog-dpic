import nimterop/cimport
import os
from macros import getProjectPath

# static:
#   cDisableCaching()
#   cDebug()

const
  meanFuncIncludePath* = getProjectPath() / "matlab_export"
static:
  doAssert fileExists(meanFuncIncludePath / "rtwtypes.h")
  doAssert fileExists(meanFuncIncludePath / "mean_func_1_types.h")
  doAssert fileExists(meanFuncIncludePath / "mean_func_1.h")
  # Put cAddSearchDir in static block:
  #  https://github.com/nimterop/nimterop/issues/122
  cAddSearchDir(meanFuncIncludePath)

cImport(cSearchPath("rtwtypes.h"))

cOverride:
  type
    emxArray_int32_T* = object
      data*: ptr UncheckedArray[cint] # this pointer needed to be fixed
      size*: ptr UncheckedArray[cint] # this pointer needed to be fixed
      allocatedSize*: cint
      numDimensions*: cint
      canFreeData*: boolean_T

# For now, we need to cimport each included file manually:
#  https://github.com/nimterop/nimterop/issues/123
cImport(cSearchPath("mean_func_1_types.h"))
cImport(cSearchPath("mean_func_1.h"))

type
  DataObj* = emxArray_int32_T
  InputObj* = struct0_T
  OutputObj* = struct1_T
