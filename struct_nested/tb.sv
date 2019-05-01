// Time-stamp: <2019-04-30 22:51:57 kmodi>

program top;

  parameter MAX = 10;

  typedef struct {
    bit scalar_bit;
    real scalar_real;
    int scalar_int;
    int arr_int[MAX];
  } level_three_s;

  typedef struct {
    bit scalar_bit;
    real scalar_real;
    int scalar_int;
    level_three_s l3;
    int arr_int[MAX];
  } level_two_s;

  typedef struct {
    bit scalar_bit;
    real scalar_real;
    int scalar_int;
    level_two_s l2;
    int arr_int[MAX];
  } level_one_s;

  import "DPI-C" printLevelOne = function void print_struct(input level_one_s s);
  import "DPI-C" populateLevelOne = function void populate_struct(output level_one_s s);

  initial begin
    begin
      level_three_s s3;
      level_two_s s2;
      level_one_s s1;

      s3 = '{scalar_bit : 1,
             scalar_real : 3.4,
             scalar_int : 300,
             arr_int : '{ 51, 58, 64, 53, 74, 54, 35, 27, 01, 38 }};

      s2 = '{scalar_bit : 0,
             scalar_real : 2.3,
             scalar_int : 200,
             l3: s3,
             arr_int : '{ 73, 17, 65, 63, 61, 38, 60, 04, 80, 36 }};

      s1 = '{scalar_bit : 1,
             scalar_real : 1.2,
             scalar_int : 100,
             l2: s2,
             arr_int : '{ 26, 68, 33, 88, 37, 07, 57, 03, 28, 72 }};

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
