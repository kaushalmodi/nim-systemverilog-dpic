import mean_func_2

let
  inputData = [ [208.cint, 1, 8, 4, 53, 06, 67, 12, 17, 32 ],
                [080.cint, 2, 6, 4, 75, 27, 50, 31, 34, 64 ],
                [304.cint, 5, 6, 8, 35, 00, 37, 42, 76, 85 ],
                [053.cint, 8, 0, 1, 78, 37, 23, 10, 10, 12 ] ]
  inp1 = [ InputObj(data: inputData[0], len: inputData[0].len.cint),
           InputObj(data: inputData[1], len: inputData[1].len.cint),
           InputObj(data: inputData[2], len: inputData[2].len.cint),
           InputObj(data: inputData[3], len: inputData[3].len.cint) ]
  out1: OutputObjRef = new(OutputObj) # initialize

mean_func(inp1, out1)

echo inputData
echo inp1
echo $out1[]
