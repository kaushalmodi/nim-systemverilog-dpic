proc get_user_input(): cstring {.exportc.} =
  stdout.write("  Nim> Enter string to be passed to SV: ")
  return readLine(stdin)
