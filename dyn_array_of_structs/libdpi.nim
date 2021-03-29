import svdpi, strformat

type
  MyObject = object
    scalar_int: cint
    scalar_string: cstring

proc print_object(objArrPtr: svOpenArrayHandle) {.exportc, dynlib.} =
  for i in 0 ..< svLength(objArrPtr, 1):
    let
      objElemPtr = cast[ptr MyObject](svGetArrElemPtr1(objArrPtr, i.cint))
    echo &"objArrPtr[][{i}] = {objElemPtr[]}"
