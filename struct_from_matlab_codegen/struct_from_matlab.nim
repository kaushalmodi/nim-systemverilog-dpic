import matlab_string

{.compile: "codegen/lib/struct_from_matlab/struct_from_matlab.c".}

type
  # Match below type with the myStruct struct in
  # ./codegen/lib/struct_from_matlab/struct_from_matlab_types.h
  MyObj* = object
    someInt16Arr*: array[5, cshort]
    someDouble*: cdouble
    someInt32Arr*: array[10, cint]
    someFloat*: cfloat
    someStr*: MatString[3]

proc struct_from_matlab*(x: ptr MyObj, y: ptr MyObj) {.importc: "$1".}

var
  x = MyObj()
  y = MyObj()
struct_from_matlab(addr x, addr y)
echo "x = ", x
echo "y = ", y
