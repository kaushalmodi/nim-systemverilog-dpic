# import nimterop/cimport
import os

# cDisableCaching()
# cDebug()

const
  # https://gitter.im/nim-lang/Nim?at=5c4e7a1754f21a71a1b8ede5
  hDir = currentSourcePath.parentDir()

# for nested includes in eggx.h
# cIncludeDir(hDir)
{.passC: "-I" & hDir.}

# {.passL: "-leggx".}
{.compile: hDir / "eggx_base.c".}
{.passL: "-lX11".}
{.passL: "-lm".}


# Mon Jan 28 11:12:52 EST 2019 - kmodi
# Do not use nimterop for now -- https://github.com/genotrance/nimterop/issues/76
# Use it only to create the initial Nim wrappers and then fix them manually.
# cAddSearchDir(hDir)
# cImport(cSearchPath("eggx.h"))
# cImport(cSearchPath("eggx_base.h"))
# cImport(cSearchPath("eggx_color.h"))

const
  # headereggx = hDir / "eggx.h"
  headereggx_base = hDir / "eggx_base.h"
  PENDOWN* = 2
  PENUP* = 3
  PSET* = 1
  FONTSET* = 0
  ENABLE* = 1
  DISABLE* = 0

proc ggetdisplayinfo*(a1: ptr cint; a2: ptr cint; a3: ptr cint): cint {.importc: "eggx_$1", header: headereggx_base.}
proc gopen*(a1: cint; a2: cint): cint {.importc: "eggx_$1", header: headereggx_base.}
proc winname*(wn: cint; a1: cstring): cint {.varargs, importc: "eggx_$1", header: headereggx_base.}
proc window*(a1: cint; a2: cfloat; a3: cfloat; a4: cfloat; a5: cfloat) {. importc: "eggx_$1", header: headereggx_base.}
proc clsc*() {.importc: "clsc_", header: headereggx_base.}
proc gclose*(a1: cint) {.importc: "eggx_$1", header: headereggx_base.}
proc gcloseall*() {.importc: "gcloseall_", header: headereggx_base.}
proc newrgbcolor*(a1: cint; a2: cint; a3: cint; a4: cint) {.importc: "eggx_$1", header: headereggx_base.}
proc newcolor*(a1: cint; a2: cstring) {.varargs, importc: "eggx_$1", header: headereggx_base.}
proc newpen*(a1: cint; a2: cint) {.importc: "eggx_$1", header: headereggx_base.}
proc gclr*(a1: cint) {.importc: "eggx_$1", header: headereggx_base.}

# Mon Jan 28 11:54:35 EST 2019 - kmodi
# https://gitter.im/nim-lang/Nim?at=5c4f314413a2814df6df6b28
# Don't use the below, clashes with line identifier in Nim frame
# proc line*(a1: cint; a2: cfloat; a3: cfloat; a4: cint) {.importc: "eggx_$1", header: headereggx_base.}

proc pset*(a1: cint; a2: cfloat; a3: cfloat) {.importc: "eggx_$1", header: headereggx_base.}
proc gsetfontset*(a1: cint; a2: cstring): cint {.varargs, importc: "eggx_$1", header: headereggx_base.}
proc drawstr*(a1: cint; a2: cfloat; a3: cfloat; a4: cint; a5: cfloat; a6: cstring) {.varargs, importc: "eggx_$1", header: headereggx_base.}
proc drawsym*(a1: cint; a2: cfloat; a3: cfloat; a4: cint; a5: cint) {.importc: "eggx_$1", header: headereggx_base.}
proc drawarrow*(a1: cint; a2: cfloat; a3: cfloat; a4: cfloat; a5: cfloat; a6: cfloat; a7: cfloat; a8: cint) {.importc: "eggx_$1", header: headereggx_base.}
proc fillarc*(a1: cint; a2: cfloat; a3: cfloat; a4: cfloat; a5: cfloat; a6: cfloat; a7: cfloat; a8: cint) {.importc: "eggx_$1", header: headereggx_base.}
proc drawarc*(a1: cint; a2: cfloat; a3: cfloat; a4: cfloat; a5: cfloat; a6: cfloat; a7: cfloat; a8: cint) {.importc: "eggx_$1", header: headereggx_base.}
proc circle*(a1: cint; a2: cfloat; a3: cfloat; a4: cfloat; a5: cfloat) {.importc: "eggx_$1", header: headereggx_base.}
proc drawrect*(a1: cint; a2: cfloat; a3: cfloat; a4: cfloat; a5: cfloat) {.importc: "eggx_$1", header: headereggx_base.}
proc fillrect*(a1: cint; a2: cfloat; a3: cfloat; a4: cfloat; a5: cfloat) {.importc: "eggx_$1", header: headereggx_base.}

# fillpoly ??

proc copylayer*(a1: cint; a2: cint; a3: cint) {.importc: "eggx_$1", header: headereggx_base.}
proc layer*(a1: cint; a2: cint; a3: cint) {.importc: "eggx_$1", header: headereggx_base.}
proc putimg24*(a1: cint; a2: cfloat; a3: cfloat; a4: cint; a5: cint; a6: ptr cuchar): cint {.importc: "eggx_$1", header: headereggx_base.}
proc ggetxpress*(a1: cint; a2: ptr cint; a3: ptr cfloat; a4: ptr cfloat): cint {.importc: "eggx_$1", header: headereggx_base.}
proc ggetch*(a1: cint): cint {.importc: "eggx_$1", header: headereggx_base.}
proc saveimg*(a1: cint; a2: cint; a3: cfloat; a4: cfloat; a5: cfloat; a6: cfloat; a7: cstring; a8: cint; a9: cstring) {.varargs, importc: "eggx_$1", header: headereggx_base.}
proc gsetborder*(a1: cint; a2: cint; a3: cstring) {.varargs, importc: "eggx_$1", header: headereggx_base.}
proc gsetbgcolor*(a1: cint; a2: cstring) {.varargs, importc: "eggx_$1", header: headereggx_base.}

proc gsetinitialattributes*(a1: cint; a2: clong) {.importc: "eggx_$1", header: headereggx_base.}
proc gsetinitialborder*(a1: cint; a2: cstring) {.varargs, importc: "eggx_$1", header: headereggx_base.}
proc gsetinitialbgcolor*(a1: cstring) {.varargs, importc: "eggx_$1", header: headereggx_base.}
proc gsetinitialparsegeometry*(a: cstring) {.varargs, importc: "eggx_$1", header: headereggx_base.}

proc gsetinitialwinname*(a1: cstring; a2: cstring; a3: cstring; a4: cstring) {.importc: "eggx_$1", header: headereggx_base.}

proc msleep*(a1: culong) {.importc: "eggx_$1", header: headereggx_base.}
proc depthinfo*(): cint {.importc: "eggx_$1", header: headereggx_base.}
proc drawnum*(a1: cint; a2: cfloat; a3: cfloat; a4: cint; a5: cfloat; a6: cfloat; a7: cint) {.importc: "eggx_$1", header: headereggx_base.}

# #define color_prms eggx_color_prms
# #define generatecolor eggx_generatecolor
# #define makecolor eggx_makecolor
#
# #define tclr() clsc_()
# #define gcloseall() gcloseall_()
# #define inkeydollar(wn) eggx_ggetch((wn))
# #define clsc() clsc_()
# #define clsx(wn) eggx_gclr((wn))
# #define plot(wn,xg,yg,mode) eggx_line((wn),(xg),(yg),(mode))
# #define arohd(wn,xs,ys,xt,yt,s,w,shape) eggx_drawarrow((wn),(xs),(ys),(xt),(yt),(s),(w),(shape))
