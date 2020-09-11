// Time-stamp: <2020-09-11 16:19:44 kmodi>

program top;

  parameter MAX = 3;

  typedef struct {
    bit scalar_bit;
    real scalar_real;
    int scalar_int;
    int arr_int[MAX];
  } some_s;

  typedef some_s some_arr_s[MAX];

  import "DPI-C" printStruct = function void print_struct(input some_arr_s s_arr);

  initial begin
    some_s s1;
    some_arr_s s_arr;

    s1 = '{scalar_bit : 1,
           scalar_real : 1.2,
           scalar_int : 100,
           arr_int : '{ 26, 68, 33 }};

    s_arr = {s1, s1, s1};


    print_struct(s_arr);
    $display("Printing from SV: s_arr = %p", s_arr);

    $finish;
  end // initial begin

endprogram : top
