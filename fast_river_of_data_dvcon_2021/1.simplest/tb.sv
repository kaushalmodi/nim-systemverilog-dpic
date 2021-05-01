// Time-stamp: <2021-04-30 21:29:44 kmodi>

program top;

  import "DPI-C" context function void f_int_nim(input int i);
  export "DPI-C" function f_int_sv;

  function void f_int_sv(input int i);
    $display("Hello from f_int_sv (%0d)", i);
  endfunction : f_int_sv

  initial begin
    f_int_nim(1);
  end

endprogram : top
