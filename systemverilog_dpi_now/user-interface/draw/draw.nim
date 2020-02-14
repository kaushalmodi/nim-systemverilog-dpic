import eggx
from math import ln

const
  myColor = DS9_B

var
  Gwin: cint = 0

proc draw_init*(width, height: cint): cint {.exportc, dynlib.} =
  gsetinitialparsegeometry("%+d%+d", Gwin * (200 + 10), 0)
  let
    win: cint = gopen(width, height) # The returned int value increments with each new window.
  layer(win, 0, 1)
  Gwin = win
  echo "Gwin = ", Gwin
  return win

proc draw_clear*(win: cint) {.exportc, dynlib.} =
  gclr(win)

proc draw_title*(win: cint; title: cstring) {.exportc, dynlib.} =
  discard winname(win, title)

proc draw_pixel*(win, x, y, n, minlimit, maxlimit: cint) {.exportc, dynlib.} =
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

proc draw_flush*(win: cint) {.exportc, dynlib.} =
  copylayer(win, 1, 0)

proc draw_finish*(win: cint) {.exportc, dynlib.} =
  draw_flush(win)
