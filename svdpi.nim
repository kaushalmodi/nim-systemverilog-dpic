import nimterop/cimport
import os

# cDisableCaching()
# cDebug()

const
  xlmIncludePath = getEnv("XCELIUM_ROOT") / ".." / "include"
static:
  doAssert fileExists(xlmIncludePath / "svdpi.h")
  doAssert fileExists(xlmIncludePath / "svdpi_compatibility.h")

cDefine("DPI_COMPATIBILITY_VERSION_1800v2012")

# Below manual definition of s_vpi_vecval is a workaround for
# https://github.com/genotrance/nimterop/issues/47.
type
  s_vpi_vecval* {.importc: "s_vpi_vecval", header: xlmIncludePath / "svdpi.h".} = object
    aval*: uint32 # we need to export the object elements too!
    bval*: uint32

cAddSearchDir(xlmIncludePath)
cImport(cSearchPath("svdpi.h"))
