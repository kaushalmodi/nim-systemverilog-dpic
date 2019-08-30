const
  Max = 3

type
  Bit = range[0.byte .. 1.byte]
  LevelTwo = object
    scalarBit: Bit
    scalarReal: cdouble
    scalarInt: cint
    arrInt: array[Max, cint]
  LevelOne = object
    scalarBit: Bit
    scalarReal: cdouble
    scalarInt: cint
    l2Arr: array[Max, LevelTwo]
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
    o2Arr = [LevelTwo(scalarBit: 0.Bit,
                      scalarReal: 70.57,
                      scalarInt: 6622,
                      arrInt: [33.cint, 40, 20]),
             LevelTwo(scalarBit: 1.Bit,
                      scalarReal: 03.67,
                      scalarInt: 6117,
                      arrInt: [05.cint, 80, 30]),
             LevelTwo(scalarBit: 1.Bit,
                      scalarReal: 00.03,
                      scalarInt: 2741,
                      arrInt: [22.cint, 76, 56])]
    o1 = LevelOne(scalarBit: 0.Bit,
                  scalarReal: 12.34,
                  scalarInt: 1100,
                  l2Arr: o2Arr,
                  arrInt: [67.cint, 44, 40])
  objPtr[] = o1
