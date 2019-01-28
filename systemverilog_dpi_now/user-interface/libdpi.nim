import svdpi
import draw/draw
import strformat
from os import sleep

when defined(test):
  proc hw_sync(count1: int) = discard
else:
  proc hw_sync(count1: int) {.importc.}

const
  thres = 4.0
  limit: int32 = 1000

# Mandel

proc get_mandel(c_real, c_imaginary: float64): int32 =
  var
    re, im: float64
    i: int32
  re = 0.0
  im = 0.0

  for idx in 0'i32 ..< limit.int32:
    var
      xsq, ysq, tmp: float64
    i = idx
    xsq = re * re
    ysq = im * im
    if xsq + ysq > thres:
      break
    tmp = xsq - ysq + c_real
    im = 2 * re * im + c_imaginary
    re = tmp
  if i == limit:
    return 0
  else:
    return i

proc c_mandel(width, height: int32; xstart, xend, ystart, yend: float64): cint {.exportc.} =
  let
    modn = width div 20
    xstep = (xend - xstart) / width.float
    ystep = (yend - ystart) / height.float
    win = draw_init(width, height)
    label = fmt"Nim (win={win}) IMG({xstart}, {ystart}) ({xend}, {yend})"

  draw_title(win, cstring(label))

  for _ in 1 .. 3:
    var
      yreal = ystart
    for y in 0 ..< height:
      var
        xreal = xstart
      for x in 0 ..< width:
        let
          n = get_mandel(xreal, yreal)
        if n > 0:
           draw_pixel(win.cint, x.cint, y.cint, n.cint, 1.cint, limit.cint)
        xreal += xstep
      hw_sync(1)
      if y mod modn == 0:
        draw_flush(win)
      yreal += ystep
    draw_finish(win)
    hw_sync(200)
    sleep(5000)                 # 5 seconds
    draw_clear(win)

  return 0 # tasks send a return value of 0

when isMainModule:
  discard c_mandel(200, 200, 0.075, 0.175, 0.59, 0.69)

# Adapted from the EGGX sample distribution:
#   http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall
