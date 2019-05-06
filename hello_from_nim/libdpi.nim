# https://github.com/nim-lang/Nim/issues/10578#issuecomment-461635978
const
  externCDecl = when defined(cpp):
                  """extern "C" $1 $2 $3"""
                else:
                  """$1 $2 $3"""

proc hello() {.exportc, codegenDecl: externCDecl.} =
  let
    str = when defined(cpp):
            "C++!"
          else:
            "C!"
  echo "Hello from Nim via " & str
