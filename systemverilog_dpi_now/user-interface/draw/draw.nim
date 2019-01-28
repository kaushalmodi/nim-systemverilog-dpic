import EGGX/eggx
from math import ln

const
  myColor = DS9_B

var
  Gwin: int32 = 0

proc draw_init*(width, height: int32): int32 {.exportc.} =
  var
    win: int32
  gsetinitialparsegeometry("%+d%+d", Gwin * (200 + 10), 0)
  win = gopen(width, height)
  layer(win, 0, 1)
  Gwin = win
  return win

proc draw_clear*(win: int32) {.exportc.} =
  gclr(win)

proc draw_title*(win: int32; title: cstring) {.exportc.} =
  discard winname(win, title)

proc draw_pixel*(win, x, y, n, minlimit, maxlimit: cint) {.exportc.} =
  var
    first = 1
    minl, maxl: float
    color_r, color_g, color_b: cint

  if first==1:
    minl = ln(float(minlimit))
    maxl = ln(float(maxlimit))
    first = 0

  discard makecolor(myColor, cfloat(minl), cfloat(maxl), cfloat(ln(float(n))), addr color_r, addr color_g, addr color_b)
  newrgbcolor(win, color_r, color_g, color_b)
  pset(win, x.cfloat, y.cfloat)

proc draw_flush*(win: int32) {.exportc.} =
  copylayer(win, 1, 0)

proc draw_finish*(win: int32) {.exportc.} =
  draw_flush(win)
