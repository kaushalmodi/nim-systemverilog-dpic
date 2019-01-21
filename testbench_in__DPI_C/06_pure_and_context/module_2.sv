// Time-stamp: <2019-01-20 22:19:20 kmodi>
// http://www.testbench.in/DP_06_PURE_AND_CONTEXT.html

module module_2;

  import "DPI-C" context function void import_func();
  export "DPI-C" function export_func;

  initial begin
    import_func();
  end

  function void export_func();
    $display("SV: My scope is %m");
  endfunction

endmodule : module_2
