// Time-stamp: <2019-03-15 07:08:57 kmodi>

program top;

  export "DPI-C" function hello_from_sv;

  import "DPI-C" context function void hello_from_nim();

  function void hello_from_sv();
    $display("Hello from SV");
  endfunction : hello_from_sv

  initial begin
    hello_from_nim();
  end

endprogram : top
