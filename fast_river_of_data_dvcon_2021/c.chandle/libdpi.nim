# Time-stamp: <2021-05-04 01:43:33 kmodi>

import std/[strformat]

type
  # Alias Nim type "pointer" to "Chandle" just for better readability.
  Chandle = pointer
  MyObject = object
    i: int
    j: int
  MyObjectRef = ref MyObject

proc f_chandle_sv(iPtr: Chandle; oPtrPtr, ioPtrPtr: ptr Chandle): Chandle {.importc.}

proc f_chandle_nim(iPtr: Chandle; oPtrPtr, ioPtrPtr: ptr Chandle): Chandle {.exportc, dynlib.} =
  var
    # Important! The global pragma is required so that this variable
    # is created in a global memory space and is available in a next
    # call of f_chandle_nim.
    myObjRef {.global.}: MyObjectRef

  if iPtr == nil:
    echo "iPtr was nil"
    myObjRef = MyObjectRef(i: 100, j: 200)
  else:
    myObjRef = cast[MyObjectRef](iPtr)
  echo &"iPtr = {repr iPtr}"
  echo &"input = {myObjRef[]}"

  discard f_chandle_sv(cast[Chandle](myObjRef), oPtrPtr, ioPtrPtr)

  let
    oPtr = cast[MyObjectRef](oPtrPtr[])
    ioPtr = cast[MyObjectRef](ioPtrPtr[])

  oPtr.i += 1
  oPtr.j += 10

  oPtrPtr[] = cast[Chandle](oPtr)
  ioPtrPtr[] = cast[Chandle](ioPtr)

  echo &"f_chandle_nim: o={oPtr[]}, io={ioPtr[]}"
  return cast[Chandle](ioPtrPtr[])
