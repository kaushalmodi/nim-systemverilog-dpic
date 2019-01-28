import nimterop/cimport
import os

# cDisableCaching()
# cDebug()

const
  # https://gitter.im/nim-lang/Nim?at=5c4e7a1754f21a71a1b8ede5
  hDir = currentSourcePath.parentDir()

# for nested includes in eggx.h
cIncludeDir(hDir)

{.passL: "-lX11".}
{.passL: "-lm".}

cPlugin:
  import strutils

  proc onSymbol(sym: var Symbol) {.exportc, dynlib.} =
    if sym.name == "IDL2__RAINBOW":
      sym.name = "IDL2_x_RAINBOW"
    else:
      sym.name = sym.name.replace("eggx_", "").strip(chars={'_'})

cOverride:
  proc gsetinitialparsegeometry*(a: cstring) {.varargs, importc: "eggx_$1", header: hDir / "eggx_base.h".}

cImport(hDir / "eggx_base.h")
cImport(hDir / "eggx_color.h")

cCompile(hDir / "eggx*.c")

# Ref: https://gitter.im/nim-lang/Nim?at=5c4f3b76c2dba5382ea13ef8
#      http://ix.io/1zqR/nim
