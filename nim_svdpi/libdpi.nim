import svdpi
import strformat

# Input: none
# Return: none
proc hello() {.exportc.} =
  echo svDpiVersion()
  echo "Hello from Nim!"
