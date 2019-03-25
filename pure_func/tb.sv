// Time-stamp: <2019-03-25 16:35:00 kmodi>

program top;

  import "DPI-C" pure function int add(input int a, b);

  initial begin
    static int a = 2;
    static int b = 3;
    $display("%0d + %0d = %0d", a, b, add(a, b));

    $finish;
  end

endprogram : top
