import strformat
from strutils import parseEnum

type
  Color = enum
    Red         # defaults to 0
    Green       # defaults to 1
    Blue = 100  # override the value to 100

  MyCustomType = range[100.cint .. 199.cint]

proc print_val1(val: Color) {.exportc, dynlib.} =
  try:
    discard parseEnum[Color]($val) # Check if val is a valid Color value
    echo fmt"val = {val}, numeric value = {ord(val)}"
  except ValueError:
    echo fmt"[Error] {ord(val)} is an invalid value for Color type"

proc print_val2(val: MyCustomType) {.exportc, dynlib.} =
  try:
    doAssert val >= low(MyCustomType) and
      val <= high(MyCustomType)
    echo fmt"val = {val}"
  except:
    echo fmt"[Error] {val} is an invalid value for MyCustomType type"
