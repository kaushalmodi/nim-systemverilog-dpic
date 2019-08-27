const
  Max = 10

type
  MyObject = object
    scalarBit: byte
    scalarReal: cdouble
    scalarInt: cint
    arrInt: array[Max, cint]
    arrBit: array[Max, byte]

proc print_object(obj: ptr MyObject) {.exportc.} =
  echo "Printing the whole object:"
  echo $obj[]
  echo "Printing the object while looping through each key:"
  for key, val in obj[].fieldPairs:
    echo "  ", $key, " = ", $val
