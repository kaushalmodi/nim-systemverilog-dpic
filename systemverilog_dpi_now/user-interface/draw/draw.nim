import EGGX/eggx

# TODO: Convert draw.c to this draw.nim

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

# proc draw_finish*(win: int32) {.exportc.} =


# proc draw_flush*(win: int32) {.exportc.} =


# proc draw_clear*(win: int32) {.exportc.} =


# proc draw_title*(win: int32; title: cstring) {.exportc.} =




# proc draw_pixel*(win, x, y, n, minlimit, maxlimit: int) {.exportc.} =
