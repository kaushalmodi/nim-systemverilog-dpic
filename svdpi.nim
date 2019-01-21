import nimterop/cimport
import os

# cDisableCaching()
# cDebug()

# Below manual definition of s_vpi_vecval is a workaround for
# https://github.com/genotrance/nimterop/issues/47.
type
  s_vpi_vecval* {.importc: "s_vpi_vecval".} = object
    aval: uint32
    bval: uint32

const
  xlmIncludePath = getEnv("XCELIUM_ROOT") / ".." / "include"
static:
  doAssert fileExists(xlmIncludePath / "svdpi.h")
  doAssert fileExists(xlmIncludePath / "svdpi_compatibility.h")

cAddSearchDir(xlmIncludePath)
cImport(cSearchPath("svdpi.h"))
