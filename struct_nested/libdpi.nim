const
  Max = 10

type
  LevelThree = object
    scalarBit: byte
    scalarReal: cdouble
    scalarInt: cint
    arrInt: array[Max, cint]
    arrBit: array[Max, byte]
  LevelTwo = object
    scalarBit: byte
    scalarReal: cdouble
    scalarInt: cint
    l3: LevelThree
    arrInt: array[Max, cint]
  LevelOne = object
    scalarBit: byte
    scalarReal: cdouble
    scalarInt: cint
    l2: LevelTwo
    arrInt: array[Max, cint]

proc printObj(obj: auto; indent = "", keyPrefix = "") =
  ## Recursive print the key/value pairs of input Nim object.
  doAssert obj is object,
    "Error: Input to printObj needs to be a Nim object"
  for key, val in obj.fieldPairs():
    when val is object:
      echo "\n" & indent & "[" & keyPrefix & $key & "]"
      printObj(val, indent & "  ", keyPrefix & $key & ".")
    else:
      echo indent & $key & " : " & $val

proc printLevelOne(objPtr: ptr LevelOne) {.exportc.} =
  printObj(objPtr[])

proc populateLevelOne(objPtr: ptr LevelOne) {.exportc.} =
  var
    o3 = LevelThree(scalarBit: 0,
                    scalarReal: 34.56,
                    scalarInt: 33_00,
                    arrInt: [30.cint, 77, 18, 72, 34, 25, 82, 15, 07, 03],
                    arrBit: [1.byte, 0, 1, 0, 1, 1, 1, 0, 1, 1 ])
    o2 = LevelTwo(scalarBit: 1,
                  scalarReal: 23.45,
                  scalarInt: 22_00,
                  l3: o3,
                  arrInt: [46.cint, 46, 15, 73, 77, 43, 33, 71, 80, 56])
    o1 = LevelOne(scalarBit: 0,
                  scalarReal: 12.34,
                  scalarInt: 11_00,
                  l2: o2,
                  arrInt: [67.cint, 44, 40, 15, 53, 30, 15, 71, 43, 34])
  objPtr[] = o1
