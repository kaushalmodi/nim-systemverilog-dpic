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
proc hello() {.exportc, dynlib.} =
  echo "Hello from Nim!"

# Input: none
# Return: int16 / short int (C) / shortint (SV) - 16-bit signed
proc ret_cshort(): cshort {.exportc, dynlib.} =
  high(cshort)

# Input: none
# Return: int32 / int (C) / int (SV) - 32-bit signed
proc ret_cint(): cint {.exportc, dynlib.} =
  high(cint)

# Input: none
# Return: int64 / long long (C) / longint (SV) - 64-bit signed
proc ret_clonglong(): clonglong {.exportc, dynlib.} =
  high(clonglong)

# Input: none
# Return: int8 / char (C) / byte (SV) - 8-bit signed
proc ret_cchar(): cchar {.exportc, dynlib.} =
  high(cchar)

# Input: none
# Return: Bit / bit - 1-bit
proc ret_bit(): Bit {.exportc, dynlib.} =
  high(Bit)

# Input: none
# Return: Logic / logic - 1-bit
proc ret_logic0(): Logic {.exportc, dynlib.} = sv0
proc ret_logic1(): Logic {.exportc, dynlib.} = sv1
proc ret_logicZ(): Logic {.exportc, dynlib.} = svZ
proc ret_logicX(): Logic {.exportc, dynlib.} = svX

# Input: none
# Return: float64 / real
proc ret_float64(): float64 {.exportc, dynlib.} =
  1.234

# Input: none
# Return: cstring / string
proc ret_cstring(): cstring {.exportc, dynlib.} =
  "Hello again"

# We cannot get pointers to consts and lets, only to vars.
# https://gitter.im/nim-lang/Nim?at=5c425d2a35350772cf52a0c1
var
  foo = @[1, 2, 3, 4]
proc ret_fooPtr(): ptr seq[int] {.exportc, dynlib.} = addr foo
proc ret_nilPtr(): ptr seq[int] {.exportc, dynlib.} = nil

type
  Animal = object
    # We need to use cstring and not string type below. Else you get the error:
    # xmsim: *E,SIGUSR: Unix Signal SIGSEGV raised from user application code.
    name, species: cstring
    age: cint
# Fri Jan 18 18:39:47 EST 2019 - kmodi
# Below does not work on the SystemVerilog side because DPI-C cannot
# accept a struct as a return type.
# *E,UNFRTN (./tb.sv,36|46): DPI function declaration has unsupported datatype as return type.
#
# proc ret_object(): Animal {.exportc, dynlib.} =
#   Animal(name: "Joe",
#          species: "H. sapiens",
#          age: 23)

# Even though SystemVerilog sends objects by values, we always receive
# them by reference/pointer on the C/Nim side. The example in the
# below question on SO helped me understand this:
# https://stackoverflow.com/questions/50351848/passing-c-structs-through-systemverilog-dpi-c-layer
proc print_object(animalAddr: ptr Animal) {.exportc, dynlib.} =
  echo &"Received {animalAddr[]} from SV."

proc print_tuple(animalAddr: ptr (cstring, cstring, cint)) {.exportc, dynlib.} =
  echo &"Received {animalAddr[]} from SV."
