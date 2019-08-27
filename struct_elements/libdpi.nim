const
  Max = 10

type
  MyObject = object
    scalarBit: byte
    scalarReal: cdouble
    scalarInt: cint
    arrInt: array[Max, cint]
    arrBit: array[Max, byte]

proc print_object(objPtr: ptr MyObject) {.exportc.} =
  echo "Printing the whole object:"
  echo $objPtr[]
  echo "Printing the object while looping through each key:"
  for key, val in objPtr[].fieldPairs:
    echo "  ", $key, " = ", $val

proc get_object(objPtr: ptr MyObject) {.exportc.} =
  var
    obj = MyObject(scalarBit: 1,
                   scalarReal: 2.3,
                   scalarInt: 456,
                   arrInt: [1.cint, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                   arrBit: [1.byte, 0, 1, 1, 1, 0, 1, 1, 0, 0])
  objPtr[] = obj
