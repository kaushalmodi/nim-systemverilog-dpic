// Time-stamp: <2019-03-25 16:33:50 kmodi>

program top;

  import "DPI-C" function void hello();

  initial begin
    hello();
    $finish;
  end

endprogram : top
