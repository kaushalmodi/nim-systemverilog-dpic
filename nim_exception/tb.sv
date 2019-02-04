// Time-stamp: <2019-02-01 18:41:23 kmodi>

program top;

  import "DPI-C" function void test_exception(input int a);

  initial begin
    test_exception(-1);
    test_exception(2);
    test_exception(0);
    $finish;
  end

endprogram
