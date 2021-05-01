import svdpi

proc hello() {.exportc, dynlib.} =
  echo svDpiVersion()
  echo "Hello from Nim!"
