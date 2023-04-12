// Time-stamp: <2023-04-12 14:07:26 kmodi>

program top;

  parameter NUM_ELEMS = 3;

  typedef struct {
    bit scalar_bit;
    real scalar_real;
    int scalar_int;
    int arr_int[NUM_ELEMS];
  } my_struct_s;

  typedef struct {
    my_struct_s arr_struct[NUM_ELEMS];
  } my_struct2_s;

  import "DPI-C" populateObjectFromToml = function void populate_struct_from_toml(input string toml_file, output my_struct_s s);
  import "DPI-C" populateObject2FromToml = function void populate_struct2_from_toml(input string toml_file, output my_struct2_s s);

  initial begin
    begin : simple_struct
      my_struct_s s1;
      populate_struct_from_toml("s1.toml", s1);
      $display("s1 = %p", s1);
    end

    begin : array_of_structs
      my_struct2_s s2;
      populate_struct2_from_toml("s2.toml", s2);
      $display("s2 = %p", s2);
    end
  end

endprogram : top
