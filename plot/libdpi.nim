import std/[strformat, os]
import svdpi
when not defined(useGgplot):
  import nimetry
else:
  import ggplotnim
  type
    XY* = (float, float)

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
      data.add((arrElemPtr[]))

    p.setX(options.xMin, options.xMax)
    p.setY(options.yMin, options.yMax)

    p.setXtic(options.xTic.float)
    p.setYtic(options.yTic.float)

    p.addPlot(data, Line)

    p.setFontTtf(srcDir / "DejaVuSans.ttf")
    if title != "":
      p.setTitle(title)

    echo &"Saving plot to {plotFile} .."
    p.save(plotFile)
  else: # ggplotnim
    # `ggplotnim` currently supports `png`, `svg` and `pdf` (and vega as proof of concept)
    plotFile = setDefaultIfNotSet(plotFile, "plot_ggplot.png")
    var
      # need the data as two sequences
      x: seq[float]
      y: seq[float]
    for i in 0.cint ..< numElems.cint:
      let
        arrElemPtr = cast[ptr XY](svGetArrElemPtr1(arrPtr, i))
      x.add arrElemPtr[][0]
      y.add arrElemPtr[][1]
    # create a dataframe from the data
    let df = seqsToDf({ "x" : x,
                        "y" : y })
    when not defined(danger):
      # just to explain a few things
      echo df # by default prints the first 20 lines of the dataframe
      # note that the columns are named after the strings we give to `seqsToDf`
      # if we want to use the names of the identifiers we could have writen
      # `let df = seqsToDf(x, y)`
      # instead btw. With the above definition however it's clearer what the
      # column names are.
      # then there's of course
      echo df.head(5) # <- creates new dataframe with only first 5 elements
      echo df.tail(5) # <- creates new dataframe with only last 5 elements
      # if one just wants to print more elements than the first 20 of a dataframe
      # use the `pretty` function directly
      echo df.pretty(30)
      # we can filter, mutate, ... the data frame
      # let's filter everything between `[xMax * 0.5, xMax * 0.75]`
      echo df.filter(f{"x" >= max("x") * 0.5 and
                       "x" <= max("x") * 0.75})
      # just so you have an idea how to write `FormulaNodes`, because almost all
      # DF related function take a formula like that. So the
      # `f{}` macro creates a formula. If printed it's printed in lisp style
      echo f{"x_norm" ~ "x" / max("x")}
      # in principle there's also untyped macros taking raw identifiers, but I wouldn't
      # rely on that.
    # now create the plot
    # `NOTE:` while font suport is in principle implemented in `ginger`, it's not exposed
    # properly yet.
    echo &"Saving plot to {plotFile} .."
    ggplot(df, aes("x", "y")) +
      geom_line() +
      ggtitle($options.title) +
      ggsave(plotFile, width = width.float, height = height.float)
    # and "it should just work ™". Since I can't run your code you have to trust me :P
  title.GC_unref()
  plotFile.GC_unref()
