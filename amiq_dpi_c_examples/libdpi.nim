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

proc compute_byte(i_value: cschar, resPtr: ptr cschar) {.exportc.} =
  logInfo "dpi_c.compute_byte(): received value {i_value}"
  resPtr[] = transform_char(i_value)
  logInfo "dpi_c.compute_byte(): return value {resPtr[]}"

proc get_byte(i_value: cschar): cschar {.exportc.} =
  logInfo "dpi_c.get_byte(): received {i_value}"
  result = transform_char(i_value);
  logInfo "dpi_c.get_byte(): return {result}"

## shortint
proc transform_short_int(inp: cshort): cshort = return cast[cshort](65535) - inp

proc compute_shortint(i_value: cshort, resPtr: ptr cshort) {.exportc.} =
  logInfo "dpi_c.compute_shortint(): received {i_value}"
  resPtr[] = transform_short_int(i_value)
  logInfo "dpi_c.compute_shortint(): return {resPtr[]}"

proc get_shortint(i_value: cshort): cshort {.exportc.} =
  logInfo "dpi_c.get_shortint(): received {i_value}"
  result = transform_short_int(i_value)
  logInfo "dpi_c.get_shortint(): return {result}"
