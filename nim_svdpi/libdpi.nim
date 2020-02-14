import svdpi
import strformat

# Input: none
# Return: none
proc hello() {.exportc, dynlib.} =
  echo svDpiVersion()
  echo "Hello from Nim!"
