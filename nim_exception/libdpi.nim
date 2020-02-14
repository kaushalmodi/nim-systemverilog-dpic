import svdpi, strformat

type
  MyError = object of Exception

proc handle_exception(a: cint)  =
  if a <= 1:
    echo fmt"a is {a}"
  else:
    raise newException(MyError, fmt"a is > 1! (value = {a})")

proc test_exception(a: cint) {.exportc, dynlib.} =
  try:
    handle_exception(a)
  except:
    echo fmt"[Error] {getCurrentException().name}: {getCurrentException().msg}"
