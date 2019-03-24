// Time-stamp: <2019-03-24 02:33:28 kmodi>

program top;

  typedef enum {RED,
                GREEN,
                BLUE=100,
                YELLOW} color_t;

  import "DPI-C" function void print_val1(input color_t x);
  import "DPI-C" function void print_val2(input int x);

  initial begin
    print_val1(RED);
    print_val1(GREEN);
    print_val1(BLUE);
    print_val1(YELLOW);

    print_val2(100);
    print_val2(199);
    print_val2(200);

    $finish;
  end

endprogram : top
