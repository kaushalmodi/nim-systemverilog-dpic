// Time-stamp: <2019-01-20 22:36:26 kmodi>
// http://www.testbench.in/DP_06_PURE_AND_CONTEXT.html

module module_1;

  import "DPI-C" context function void import_func();
  export "DPI-C" function export_func;

  module_2 u_mod_2();

  initial begin
    import_func();
    $finish;
  end

  function void export_func();
    $display("SV: My scope is %m");
  endfunction

endmodule : module_1
