import svdpi
import draw/[draw, nim_mandel]

proc c_mandel(width, height: int32; xstart, xend, ystart, yend: float64): cint {.exportc.} =
  mandel(width, height, xstart, xend, ystart, yend, 3)
  return 0 # tasks send a return value of 0

# Adapted from the EGGX sample distribution:
#   http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall
