import svdpi
import draw/[draw, nim_mandel]

proc hw_sync(cnt: cint) {.importc, gcsafe, noSideEffect.}

proc c_mandel(width, height: cint; xstart, xend, ystart, yend: float; repeat_cnt: cint): cint {.exportc.} =
  let
    xScale = 1.0
    yScale = 1.0
  mandel(width, height, xScale, yScale, xstart, xend, ystart, yend, repeat_cnt, hw_sync)
  return 0 # tasks send a return value of 0

# Adapted from the EGGX sample distribution:
#   http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall
