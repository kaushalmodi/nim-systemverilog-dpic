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
{.compile: hDir / "eggx_color.c".}

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


# eggx_color.h bindings

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

const
  headereggx_color = hDir / "eggx_color.h"
  CP_NONE* = 0
  DS9_GREY* = 0
  DS9_GRAY* = 0
  DS9_RED* = 1
  DS9_GREEN* = 2
  DS9_BLUE* = 3
  DS9_A* = 4
  DS9_B* = 5
  DS9_BB* = 6
  DS9_HE* = 7
  DS9_I8* = 8
  DS9_AIPS0* = 9
  DS9_SLS* = 10
  DS9_HEAT* = 11
  DS9_COOL* = 12
  DS9_RAINBOW* = 13
  DS9_STANDARD* = 14
  DS9_STAIRCASE* = 15
  DS9_COLOR* = 16
  DS9_BEGIN* = 0
  DS9_NUM* = 17
  IDL1_B_W_LINEAR* = 17
  IDL1_BLUE_WHITE* = 18
  IDL1_GRN_RED_BLU_WHT* = 19
  IDL1_RED_TEMPERATURE* = 20
  IDL1_BLUE_GREEN_RED_YELLOW* = 21
  IDL1_STD_GAMMA_II* = 22
  IDL1_PRISM* = 23
  IDL1_RED_PURPLE* = 24
  IDL1_GREEN_WHITE_LINEAR* = 25
  IDL1_RGN_WHT_EXPONENTIAL* = 26
  IDL1_GREEN_PINK* = 27
  IDL1_BLUE_RED* = 28
  IDL1_16_LEVEL* = 29
  IDL1_RAINBOW* = 30
  IDL1_STEPS* = 31
  IDL1_STERN_SPECIAL* = 32
  IDL1_BEGIN* = 17
  IDL1_NUM* = 16
  IDL2_HAZE* = 33
  IDL2_BLUE_PASTEL_RED* = 34
  IDL2_PASTELS* = 35
  IDL2_HUE_SAT_LIGHTNESS_1* = 36
  IDL2_HUE_SAT_LIGHTNESS_2* = 37
  IDL2_HUE_SAT_VALUE_1* = 38
  IDL2_HUE_SAT_VALUE_2* = 39
  IDL2_PURPLE_RED_WITH_STRIPES* = 40
  IDL2_BEACH* = 41
  IDL2_MAC_STYLE* = 42
  IDL2_EOS_A* = 43
  IDL2_EOS_B* = 44
  IDL2_HARDCANDY* = 45
  IDL2_NATURE* = 46
  IDL2_OCEAN* = 47
  IDL2_PEPPERMINT* = 48
  IDL2_PLASMA* = 49
  IDL2_BLUE_RED* = 50
  IDL2_RAINBOW* = 51
  IDL2_BLUE_WAVES* = 52
  IDL2_VALCANO* = 53
  IDL2_WAVES* = 54
  IDL2_RAINBOW18* = 55
  IDL2_ORBIT_VIEWER_COLOR* = 57
  IDL2_ORBIT_VIEWER_GREY* = 58
  EGGX_COLOR_BEGIN* = 0
type
  color_prms* {.importc: "struct eggx_color_prms", header: headereggx_color, bycopy.} = object
    colormode*: cint
    flags*: cint
    contrast*: cfloat
    brightness*: cfloat
    gamma*: cfloat
    seplevel*: cint
    `ptr`*: pointer
    function*: proc (a1: cfloat; a2: pointer; a3: cfloat; a4: cfloat; a5: cfloat; a6: ptr cfloat; a7: ptr cfloat; a8: ptr cfloat) {.nimcall.}

proc generatecolor*(a1: ptr color_prms; a2: cfloat; a3: cfloat; a4: cfloat; a5: ptr cint; a6: ptr cint; a7: ptr cint): cint {.importc: "eggx_$1", header: headereggx_color.}
proc makecolor*(a1: cint; a2: cfloat; a3: cfloat; a4: cfloat; a5: ptr cint; a6: ptr cint; a7: ptr cint): cint {.importc: "eggx_$1", header: headereggx_color.}
