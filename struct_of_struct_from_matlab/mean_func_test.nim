import mean_func_2

let
  inputData = [ [632.cint, 68, 87, 73, 22, 63, 20, 04, 88, 85 ],
                [104.cint, 36, 53, 35, 00, 36, 51, 73, 74, 08 ],
                [080.cint, 83, 60, 66, 77, 50, 40, 64, 07, 24 ] ]
  inp1 = [ InputObj(data: inputData[0], len: inputData[0].len.cint),
           InputObj(data: inputData[1], len: inputData[1].len.cint),
           InputObj(data: inputData[2], len: inputData[2].len.cint) ]
  out1: OutputObjRef = new(OutputObj) # initialize

mean_func(inp1, out1)

echo inputData
echo inp1
echo $out1[]
