import draw
import strformat
from os import sleep

proc hw_sync_placeholder(cnt: int) = discard

const
  thres = 4.0
  limit: int32 = 1000

# Mandel

proc get_mandel(c_real, c_imaginary: float64): int32 =
  var
    i: int32
    re, im: float64

  while true:
    let
      xsq = re * re
      ysq = im * im
    if xsq + ysq > thres:
      break
    im = 2 * re * im + c_imaginary
    re = xsq - ysq + c_real
    i += 1
    if i >= limit:
      return 0
  return i

proc mandel*(winWidth  = 200,
             winHeight = 200,
             xScale    = 1.0,
             yScale    = 1.0,
             realBegin = 0.075,
             realEnd   = 0.175,
             imagBegin = 0.59,
             imagEnd   = 0.69,
             repeat    = 1,
             hw_sync   = hw_sync_placeholder) =
  let
    modn = winWidth div 20
    xstep = xScale * (realEnd - realBegin) / winWidth.float
    ystep = yScale * (imagEnd - imagBegin) / winHeight.float
    win = draw_init(winWidth.int32, winHeight.int32)
    label = fmt"Nim (win={win}) IMG({realBegin}, {imagBegin}) ({realEnd}, {imagEnd})"

  draw_title(win, cstring(label))

  for _ in 1 .. repeat:
    var
      yreal = imagBegin
    for y in 0 ..< winHeight:
      var
        xreal = realBegin
      for x in 0 ..< winWidth:
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

when isMainModule:
  mandel()

# Adapted from the EGGX sample distribution:
#   http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall
