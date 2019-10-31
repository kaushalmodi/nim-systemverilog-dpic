import std/[strformat, os]
import svdpi, nimetry

const
  srcDir = currentSourcePath.parentDir() # dir containing this .nim file

type
  PlotOptions = object
    widthPixels: cuint
    heightPixels: cuint
    title: cstring
    filePath: cstring
    xMin: cdouble
    xMax: cdouble
    yMin: cdouble
    yMax: cdouble
    xTic: cdouble
    yTic: cdouble

proc setDefaultIfNotSet[T](val: T; defaultVal: T): T =
  result = val
  when T is string:
    if val == "":
      return defaultVal
  else:
    if val == 0:
      return defaultVal

proc plot(numElems: cuint; arrPtr: svOpenArrayHandle; optionsPtr: ptr PlotOptions){.exportc.} =
  let
    arrLen = svLength(arrPtr, 1).cuint
    options = optionsPtr[]
    width = setDefaultIfNotSet(options.widthPixels, 720)
    height = setDefaultIfNotSet(options.widthPixels, 480)
    plotFile = setDefaultIfNotSet($options.filePath, "plot.png")
  doAssert numElems <= arrLen
  # echo options
  var
    data: seq[XY]
    p: Plot = newPlot(width.int, height.int)
  for i in 0.cint ..< numElems.cint:
    let
      arrElemPtr = cast[ptr XY](svGetArrElemPtr1(arrPtr, i))
    data.add((arrElemPtr[]))

  p.setX(options.xMin, options.xMax)
  p.setY(options.yMin, options.yMax)

  p.setXtic(options.xTic.float)
  p.setYtic(options.yTic.float)

  p.addPlot(data, Scatter, rgba(255, 0, 0, 255))

  p.setFontTtf(srcDir / "DejaVuSans.ttf")
  if $options.title != "":
    p.setTitle($options.title)

  echo &"Saving plot to {plotFile} .."
  p.save(plotFile)
