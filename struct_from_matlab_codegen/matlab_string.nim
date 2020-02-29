type
  MatCharArr*[N: static int] = object
    data*: array[N, char]
    sz*: array[2, cint]
  MatString*[N: static int] = object
    val*: MatCharArr[N]

proc `$`*(s: MatString): string =
  let
    strLen = max(s.val.sz[0], s.val.sz[1])
  for i in 0 ..< strLen:
    result.add(s.val.data[i])
