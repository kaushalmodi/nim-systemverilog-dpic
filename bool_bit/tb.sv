// Time-stamp: <2022-09-02 16:55:46 kmodi>

program top;

  parameter NUM_ELEMS = 3;

  typedef struct {
    bit scalar_bit;
    real scalar_real;
    bit arr_bit[NUM_ELEMS];
    int scalar_int;
  } my_struct_s;

  typedef struct {
    bit scalar_bit;
    bit arr_bit[NUM_ELEMS];
    int scalar_int;
    real scalar_real;
  } my_eff_struct_s;

  import "DPI-C" printMyObj = function void print_struct(input my_struct_s s);
  import "DPI-C" populateMyObj = function void populate_struct(output my_struct_s s);

  import "DPI-C" printMyEffObj = function void print_eff_struct(input my_eff_struct_s s);
  import "DPI-C" populateMyEffObj = function void populate_eff_struct(output my_eff_struct_s s);

  initial begin
    begin
      my_struct_s s1;

      s1 = '{ scalar_bit : 1
              , scalar_real : 1.2
              , arr_bit: '{0, 1, 0}
              , scalar_int : 2345
              };

      print_struct(s1);
    end

    begin
      my_struct_s s1;

      $display("Populating and printing my_struct_s object ..");
      populate_struct(s1);
      print_struct(s1);
    end

    begin
      my_eff_struct_s s1;

      $display("Populating and printing my_eff_struct_s object ..");
      populate_eff_struct(s1);
      print_eff_struct(s1);
    end

    $finish;
  end // initial begin

endprogram : top
