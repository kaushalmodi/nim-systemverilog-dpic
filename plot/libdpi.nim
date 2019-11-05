import std/[strformat, os]
import svdpi, nimetry

type
  # Araq recommended to always use the {.bycopy.} pragma for mapping
  # Nim types to SV types (especially the ones related to cstring):
  # https://gitter.im/nim-lang/Nim?at=5dc1a48d2a6494729ca24f89.
  PlotOptions {.bycopy.} = object
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
    height = setDefaultIfNotSet(options.heightPixels, 480)
  var
    title, plotFile: string
  title.GC_ref()
  plotFile.GC_ref()
  title = $options.title
  plotFile = $options.filePath
  doAssert numElems <= arrLen
  # echo options
  when not defined(useGgplot):
    const
      srcDir = currentSourcePath.parentDir() # dir containing this .nim file
    plotFile = setDefaultIfNotSet(plotFile, "plot.png")
    var
      data: seq[XY]
      p: Plot = newPlot(width.int, height.int)
    for i in 0.cint ..< numElems.cint:
      let
        arrElemPtr = cast[ptr XY](svGetArrElemPtr1(arrPtr, i))
      data.add(arrElemPtr[])

    p.setX(options.xMin, options.xMax)
    p.setY(options.yMin, options.yMax)

    p.setXtic(options.xTic.float)
    p.setYtic(options.yTic.float)

    p.addPlot(data, Line)

    p.setFontTtf(srcDir / "DejaVuSans.ttf")
    if title != "":
      p.setTitle(title)

    # echo &"Saving plot to {plotFile} .."
    p.save(plotFile)
  title.GC_unref()
  plotFile.GC_unref()
