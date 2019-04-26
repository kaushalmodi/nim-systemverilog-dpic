// Time-stamp: <2019-04-26 15:06:18 kmodi>

program top;

  import "DPI-C" function void hello_from_cpp();

  initial begin
    hello_from_cpp();
    $finish;
  end

endprogram : top
