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
cCompile(hDir / "eggx*.c")

cPlugin:
  import strutils

  proc onSymbol(sym: var Symbol) {.exportc, dynlib.} =
    if sym.name == "IDL2__RAINBOW":
      # Fixes:
      # Error: unhandled exception: nimterop/getters.nim(133, 16)
      # `name == existing[nimName]` Identifier 'IDL2__RAINBOW' is a
      # stylistic duplicate of identifier 'IDL2_RAINBOW', use
      # 'cPlugin:onSymbol()' to rename
      sym.name = "IDL2_x_RAINBOW"
    else:
      sym.name = sym.name.replace("eggx_", "").strip(chars={'_'})

const
  headereggx_base0 = hDir / "eggx_base.h"
  headereggx_color0 = hDir / "eggx_color.h"

# This block must be added before the cImport for which the overrides
# are happening.
cOverride:
  # Workaround for tree-sitter not passing varargs info to nimterop:
  #   https://github.com/genotrance/nimterop/issues/76
  {.push varargs.}
  {.push header: headereggx_base0.}
  proc winname*(wn: cint; a1: cstring): cint                                              {.importc: "eggx_$1".}
  proc newcolor*(a1: cint; a2: cstring)                                                   {.importc: "eggx_$1".}
  proc gsetfontset*(a1: cint; a2: cstring): cint                                          {.importc: "eggx_$1".}
  proc drawstr*(a1: cint; a2, a3: cfloat; a4: cint; a5: cfloat; a6: cstring)              {.importc: "eggx_$1".}
  proc saveimg*(a1, a2: cint; a3, a4, a5, a6: cfloat; a7: cstring; a8: cint; a9: cstring) {.importc: "eggx_$1".}
  proc gsetborder*(a1, a2: cint; a3: cstring)                                             {.importc: "eggx_$1".}
  proc gsetbgcolor*(a1: cint; a2: cstring)                                                {.importc: "eggx_$1".}
  proc gsetinitialborder*(a1: cint; a2: cstring)                                          {.importc: "eggx_$1".}
  proc gsetinitialbgcolor*(a1: cstring)                                                   {.importc: "eggx_$1".}
  proc gsetinitialparsegeometry*(a: cstring)                                              {.importc: "eggx_$1".}
  {.pop.} # {.push header: headereggx_base0.}
  {.pop.} # {.push varargs.}

cImport(headereggx_base0)
cImport(headereggx_color0)

# Ref: https://gitter.im/nim-lang/Nim?at=5c4f3b76c2dba5382ea13ef8
#      http://ix.io/1zqR/nim
