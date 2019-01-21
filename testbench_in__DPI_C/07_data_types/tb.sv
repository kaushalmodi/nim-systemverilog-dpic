// Time-stamp: <2019-01-20 22:46:57 kmodi>
// http://www.testbench.in/DP_07_DATA_TYPES.html

program main;

  import "DPI-C" function void show (logic a);

  logic a;

  initial begin
    a = 1'b0;
    show(a);
    a = 1'b1;
    show(a);
    a = 1'bX;
    show(a);
    a = 1'bZ;
    show(a);
    $finish;
  end // initial begin

endprogram
