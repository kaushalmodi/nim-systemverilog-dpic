# https://github.com/nim-lang/Nim/issues/10578#issuecomment-461635978

proc hello() {.exportc, dynlib.} =
  let
    str = when defined(cpp):
            "C++!"
          else:
            "C!"
  echo "Hello from Nim via " & str
