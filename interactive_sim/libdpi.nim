proc get_user_input(): cstring {.exportc, dynlib.} =
  stdout.write("  Nim> Enter string to be passed to SV: ")
  return readLine(stdin)
