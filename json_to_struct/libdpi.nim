when defined(jsony):
  import jsony
else:
  import std/[json, jsonutils]

const
  numElems = 3

when defined(jsony):
  # jsony is able to match snake_case keys in the JSON with camelCase
  # elements in the Nim objects.
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

else:
  # jsonutils.jsonTo requires the JSON keys to match exactly with the
  # object element names.
  type
    MyObject = object
      scalar_bit: bool
      scalar_real: cdouble
      scalar_int: cint
      arr_int: array[numElems, cint]

    MyObject2 = object
      arr_obj: array[numElems, MyObject]

  proc getObjectFromJsonFile[T](jsonFile: string): T =
    return jsonFile.readFile().parseJson().jsonTo(T)

proc populateObjectFromJson(jsonFile: cstring; objPtr: ptr MyObject) {.exportc, dynlib.} =
  objPtr[] = getObjectFromJsonFile[MyObject]($jsonFile)
  #                                          ^ The $ converts cstring to Nim string.

proc populateObject2FromJson(jsonFile: cstring; objPtr: ptr MyObject2) {.exportc, dynlib.} =
  objPtr[] = getObjectFromJsonFile[MyObject2]($jsonFile)
