import std/[strformat]
import svdpi, nimetry

type
  XyData = tuple
    cnt: cuint
    sin: cdouble
  XyDataF = tuple
    x: float
    y: float

proc plot(numElems: cuint; arrPtr: svOpenArrayHandle; fileName: cstring){.exportc.} =
  var
    data: seq[XyDataF]
    p: Plot = newPlot(720, 480)
  let
    arrLen = svLength(arrPtr, 1).cuint
  doAssert numElems <= arrLen
  for i in 0.cint ..< numElems.cint:
    let
      arrElemPtr = cast[ptr XyData](svGetArrElemPtr1(arrPtr, i))
    # echo &"{i}: {arrElemPtr[]}"
    data.add((arrElemPtr[].cnt.float, arrElemPtr[].sin.float))

  p.setX(0, data[data.high].x+1)
  p.setY(-1.0, 1.0)

  p.setXtic(200)
  p.setYtic(0.1)

  p.addPlot(data, Scatter, rgba(255, 0, 0, 255))

  p.setFontTtf("DejaVuSans.ttf")
  p.setTitle("Plot cnt vs sin")

  p.save($fileName)
