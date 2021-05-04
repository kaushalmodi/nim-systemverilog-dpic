// Time-stamp: <2021-05-03 22:14:54 kmodi>

module other_module();

  export "DPI-C" function f_scopetest_sv;

  function void f_scopetest_sv();
    $display("In %m\n");
  endfunction : f_scopetest_sv

endmodule : other_module

module top();

  import "DPI-C" context function void f_scopetest_nim();
  export "DPI-C" function f_scopetest_sv;

  other_module u_other_module();

  function void f_scopetest_sv();
    $display("In %m\n");
  endfunction : f_scopetest_sv

  initial begin
    f_scopetest_nim();
  end

endmodule : top
