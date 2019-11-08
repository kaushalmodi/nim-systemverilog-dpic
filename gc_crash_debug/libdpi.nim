proc imported_func(){.exportc.} =
  # https://gitter.im/nim-lang/Nim?at=5dc584763f4ea333f2c5345d
  when defined(gcToggle):
    GC_disable()
  var
    someStr: string
  for i in 0 .. 1000:
    someStr = $i & "aaaaaaaaaaaaaaa"
  when defined(gcToggle):
    GC_enable()
