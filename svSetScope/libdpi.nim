# https://verificationacademy.com/forums/systemverilog/how-bind-dpi-files-and-testbench-files#answer-45143
import svdpi

proc dpisv_RegRead32(offset: cuint, data: ptr cuint): cint {.importc.}

proc doTest(offset: cuint, data: ptr cuint): cint {.exportc.} =
  let
    gScope = svGetScopeFromName("reftb_dpi.tbench_i")
  discard svSetScope(gScope)
  # If I comment out the above line, I get this error:
  #   xmsim: *E,NOTEXP: The current scope "reftb_dpi" does not
  #   have any export declaration corresponding to C identifier
  #   "dpisv_RegRead32".
  return dpisv_RegRead32(offset, data)
