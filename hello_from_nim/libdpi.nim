when defined(cpp):
  {.push codegenDecl: """extern "C" $1 $2 $3""".}

proc hello() {.exportc.} =
  echo "Hello from Nim!"

when defined(cpp):
  {.pop.}
