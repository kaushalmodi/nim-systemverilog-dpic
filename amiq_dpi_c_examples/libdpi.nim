from strutils import `%`
import svdpi, strformat

template logInfo(data: string): untyped =
  let
    pos = instantiationInfo()
    lineInfo = "[INFO]($1:$2:) " % [pos.filename, $pos.line]
  echo lineInfo & fmt(data)

## byte
proc transform_char(inp: cschar): cschar =
  echo fmt"transform_char in: {inp}"
  # The original C code seems to have a bug .. the C side compute_byte
  # is mapped with SV "byte" type, but the "byte" type is 8-bit
  # signed. 255 is an invalid 8-bit signed value. So I need to force
  # cast it to an 8-bit signed value to make the Nim code compile.
  return cast[cschar](255) - inp

proc compute_byte(i_value: cschar; resPtr: ptr cschar) {.exportc.} =
  logInfo "dpi_c.compute_byte(): received value {i_value}"
  resPtr[] = transform_char(i_value)
  logInfo "dpi_c.compute_byte(): return value {resPtr[]}"

proc get_byte(i_value: cschar): cschar {.exportc.} =
  logInfo "dpi_c.get_byte(): received {i_value}"
  result = transform_char(i_value);
  logInfo "dpi_c.get_byte(): return {result}"

## shortint
proc transform_short_int(inp: cshort): cshort = cast[cshort](65535) - inp

proc compute_shortint(i_value: cshort; resPtr: ptr cshort) {.exportc.} =
  logInfo "dpi_c.compute_shortint(): received {i_value}"
  resPtr[] = transform_short_int(i_value)
  logInfo "dpi_c.compute_shortint(): return {resPtr[]}"

proc get_shortint(i_value: cshort): cshort {.exportc.} =
  logInfo "dpi_c.get_shortint(): received {i_value}"
  result = transform_short_int(i_value)
  logInfo "dpi_c.get_shortint(): return {result}"

## int
proc transform_int(inp: cint): cint = 23*inp

proc compute_int(i_value: cint; resPtr: ptr cint) {.exportc.} =
  logInfo "dpi_c.compute_int(): received {i_value}"
  resPtr[] = transform_int(i_value)
  logInfo "dpi_c.compute_int(): return {resPtr[]}"

proc get_int(i_value: cint): cint {.exportc.} =
  logInfo "dpi_c.get_int(): received {i_value}"
  result = transform_int(i_value)
  logInfo "dpi_c.get_int(): return {result}"

## longint
# The original C code has some bug .. it prints:
#  test.test_longint calls compute_longint with   2809549300312324577
#  [INFO](libdpi.c:75:) dpi_c.compute_longint(): received -133154335   <-- incorrect received value
#  [INFO](libdpi.c:77:) dpi_c.compute_longint(): return 801885979
#  [INFO](libdpi.c:81:) dpi_c.get_longint(): received -133154335
#  [INFO](libdpi.c:83:) dpi_c.get_longint(): return 801885979
# Whereas Nim correctly prints:
#  int calls compute_longint with   2809549300312324577
#  [INFO](libdpi.nim:59:) dpi_c.compute_longint(): received 2809549300312324577
#  [INFO](libdpi.nim:61:) dpi_c.compute_longint(): return -4913573462065557733
#  [INFO](libdpi.nim:64:) dpi_c.get_longint(): received 2809549300312324577
#  [INFO](libdpi.nim:66:) dpi_c.get_longint(): return -4913573462065557733

proc transform_long_int(inp: clonglong): clonglong = 123*inp

proc compute_longint(i_value: clonglong; resPtr: ptr clonglong) {.exportc.} =
  logInfo "dpi_c.compute_longint(): received {i_value}"
  resPtr[] = transform_long_int(i_value)
  logInfo "dpi_c.compute_longint(): return {resPtr[]}"

proc get_longint(i_value: clonglong): clonglong {.exportc.} =
  logInfo "dpi_c.get_longint(): received {i_value}"
  result = transform_long_int(i_value)
  logInfo "dpi_c.get_longint(): return {result}"

## real
proc transform_double(inp: cdouble): cdouble = inp*3

proc compute_real(i_value: cdouble; resPtr: ptr cdouble) {.exportc.} =
  logInfo "dpi_c.compute_real(): received {i_value}"
  resPtr[] = transform_double(i_value)
  logInfo "dpi_c.compute_real(): return {resPtr[]}"

proc get_real(i_value: cdouble): cdouble {.exportc.} =
  logInfo "dpi_c.get_real(): received {i_value}"
  result = transform_double(i_value)
  logInfo "dpi_c.get_real(): return {result}"

## string
proc compute_string(i_value: cstring; resPtr: ptr cstring) {.exportc.} =
  logInfo "dpi_c.compute_string(): received {i_value}"
  resPtr[] = "DEAF_BEAF_DRINKS_COFFEE"
  logInfo "dpi_c.compute_string(): return {resPtr[]}"

proc get_string(i_value: cstring): cstring {.exportc.} =
  logInfo "dpi_c.get_string(): received {i_value}"
  result = "DEAF_BEAF_DRINKS_COFFEE"
  logInfo "dpi_c.get_string(): return {result}"
