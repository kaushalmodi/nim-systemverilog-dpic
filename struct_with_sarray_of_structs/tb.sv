// Time-stamp: <2019-08-30 09:32:42 kmodi>

program top;

  parameter MAX = 3;

  typedef struct {
    bit scalar_bit;
    real scalar_real;
    int scalar_int;
    int arr_int[MAX];
  } level_two_s;

  typedef struct {
    bit scalar_bit;
    real scalar_real;
    int scalar_int;
    level_two_s l2_arr[MAX];
    int arr_int[MAX];
  } level_one_s;

  import "DPI-C" printLevelOne = function void print_struct(input level_one_s s);
  import "DPI-C" populateLevelOne = function void populate_struct(output level_one_s s);

  initial begin
    begin
      level_two_s s2_arr[MAX];
      level_one_s s1;

      s2_arr = '{
                 '{scalar_bit : 0,
                   scalar_real : 8.0,
                   scalar_int : 560,
                   arr_int : '{ 11, 36, 53 }},
                 '{scalar_bit : 1,
                   scalar_real : 3.5,
                   scalar_int : 786,
                   arr_int : '{ 57, 18, 61 }},
                 '{scalar_bit : 0,
                   scalar_real : 6.6,
                   scalar_int : 660,
                   arr_int : '{ 48, 33, 47 }}
                 };

      s1 = '{scalar_bit : 1,
             scalar_real : 1.2,
             scalar_int : 100,
             l2_arr: s2_arr,
             arr_int : '{ 26, 68, 33 }};

      print_struct(s1);
      $display("");
    end

    begin
      level_one_s s1;
      populate_struct(s1);
      print_struct(s1);
    end

    $finish;
  end // initial begin

endprogram : top
