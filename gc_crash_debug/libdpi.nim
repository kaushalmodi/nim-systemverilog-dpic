proc imported_func(){.exportc.} =
  var
    someStr: string
  for i in 0 .. 1000:
    someStr = $i & "aaaaaaaaaaaaaaa"
