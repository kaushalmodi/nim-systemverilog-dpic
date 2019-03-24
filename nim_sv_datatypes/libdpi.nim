import strformat

type
  Logic = enum
    sv0 = 0
    sv1
    svZ
    svX
  Bit = range[sv0 .. sv1]

# Input: none
# Return: none
proc hello() {.exportc.} =
  echo "Hello from Nim!"

# Input: none
# Return: int16 / short int (C) / shortint (SV) - 16-bit signed
proc ret_cshort(): cshort {.exportc.} =
  high(cshort)

# Input: none
# Return: int32 / int (C) / int (SV) - 32-bit signed
proc ret_cint(): cint {.exportc.} =
  high(cint)

# Input: none
# Return: int64 / long long (C) / longint (SV) - 64-bit signed
proc ret_clonglong(): clonglong {.exportc.} =
  high(clonglong)

# Input: none
# Return: int8 / char (C) / byte (SV) - 8-bit signed
proc ret_cchar(): cchar {.exportc.} =
  high(cchar)

# Input: none
# Return: Bit / bit - 1-bit
proc ret_bit(): Bit {.exportc.} =
  high(Bit)

# Input: none
# Return: Logic / logic - 1-bit
proc ret_logic0(): Logic {.exportc.} = sv0
proc ret_logic1(): Logic {.exportc.} = sv1
proc ret_logicZ(): Logic {.exportc.} = svZ
proc ret_logicX(): Logic {.exportc.} = svX

# Input: none
# Return: float64 / real
proc ret_float64(): float64 {.exportc.} =
  1.234

# Input: none
# Return: cstring / string
proc ret_cstring(): cstring {.exportc.} =
  "Hello again"

# We cannot get pointers to consts and lets, only to vars.
# https://gitter.im/nim-lang/Nim?at=5c425d2a35350772cf52a0c1
var
  foo = @[1, 2, 3, 4]
proc ret_fooPtr(): ptr seq[int] {.exportc.} = addr foo
proc ret_nilPtr(): ptr seq[int] {.exportc.} = nil

type
  Animal = object
    name, species: cstring
    age: cint
# Fri Jan 18 18:39:47 EST 2019 - kmodi
# Below does not work on the SystemVerilog side because DPI-C cannot
# accept a struct as a return type.
# *E,UNFRTN (./tb.sv,36|46): DPI function declaration has unsupported datatype as return type.
#
# proc ret_object(): Animal {.exportc.} =
#   Animal(name: "Joe",
#          species: "H. sapiens",
#          age: 23)

# Even though SystemVerilog sends objects by values, we always receive
# them by reference on the C/Nim side. The example in the question on
# https://stackoverflow.com/questions/50351848/passing-c-structs-through-systemverilog-dpi-c-layer
# helped me understand this.
proc print_object(animalAddr: ref Animal) {.exportc.} =
  withScratchRegion:
    echo fmt"Received {animalAddr[]} from SV."
