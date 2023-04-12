import toml_serialization

const
  numElems = 3

type
  MyObject = object
    scalar_bit: bool
    scalar_real: cdouble
    scalar_int: cint
    arr_int: array[numElems, cint]

  MyObject2 = object
    arr_obj: array[numElems, MyObject]

proc getObjectFromTomlFile[T](tomlFile: string): T =
  return Toml.decode(readFile(tomlFile), T)

proc populateObjectFromToml(tomlFile: cstring; objPtr: ptr MyObject) {.exportc, dynlib.} =
  objPtr[] = getObjectFromTomlFile[MyObject]($tomlFile)
  #                                          ^ The $ converts cstring to Nim string.

proc populateObject2FromToml(tomlFile: cstring; objPtr: ptr MyObject2) {.exportc, dynlib.} =
  objPtr[] = getObjectFromTomlFile[MyObject2]($tomlFile)
