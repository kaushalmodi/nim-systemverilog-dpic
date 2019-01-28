import svdpi
import draw/[draw, nim_mandel]

proc hw_sync(cnt: int) {.importc, gcsafe, noSideEffect.}

proc c_mandel(width, height: int32; xstart, xend, ystart, yend: float64): cint {.exportc.} =
  let
    xScale = 1.0
    yScale = 1.0
  mandel(width, height, xScale, yScale, xstart, xend, ystart, yend, 3, hw_sync)
  return 0 # tasks send a return value of 0

# Adapted from the EGGX sample distribution:
#   http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall
