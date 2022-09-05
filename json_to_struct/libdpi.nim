import jsony

const
  numElems = 3

type
  MyObject = object
    scalarBit: bool
    scalarReal: cdouble
    scalarInt: cint
    arrInt: array[numElems, cint]

  MyObject2 = object
    arrObj: array[numElems, MyObject]

proc getObjectFromJsonFile[T](jsonFile: string): T =
  return jsonFile.readFile().fromJson(T)

proc populateObjectFromJson(jsonFile: cstring; objPtr: ptr MyObject) {.exportc, dynlib.} =
  objPtr[] = getObjectFromJsonFile[MyObject]($jsonFile)

proc populateObject2FromJson(jsonFile: cstring; objPtr: ptr MyObject2) {.exportc, dynlib.} =
  objPtr[] = getObjectFromJsonFile[MyObject2]($jsonFile)
