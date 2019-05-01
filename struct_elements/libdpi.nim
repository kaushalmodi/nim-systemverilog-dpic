import svdpi

const
  Max = 10

type
  MyObject = object
    scalar_bit: byte
    scalar_real: cdouble
    scalar_int: cint
    arr_int: array[Max, cint]

proc print_object(obj: ptr MyObject) {.exportc.} =
  echo "Printing the whole object:"
  echo $obj[]
  echo "Printing the object while looping through each key:"
  for key, val in obj[].fieldPairs:
    echo "  ", $key, " = ", $val
