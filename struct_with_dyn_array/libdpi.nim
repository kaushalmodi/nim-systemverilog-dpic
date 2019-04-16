import svdpi, strformat

type
  MyObject = object
    scalar_int: cint
    dyn_arr_int_handle: svOpenArrayHandle

proc print_object(obj: ptr MyObject) {.exportc.} =
  echo fmt"obj.scalar_int = {obj[].scalar_int}"
  let
    handle = obj[].dyn_arr_int_handle
  for i in 0 ..< svLength(handle, 1):
    let
      intElemPtr = cast[ptr cint](svGetArrElemPtr1(handle, 1))
    echo fmt"obj.dyn_arr_int_handle[][{i}] = {intElemPtr[]}"
