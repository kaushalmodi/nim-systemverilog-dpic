// Time-stamp: <2022-09-05 14:21:22 kmodi>

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

  import "DPI-C" populateObjectFromJson = function void populate_struct_from_json(input string json_file, output my_struct_s s);
  import "DPI-C" populateObject2FromJson = function void populate_struct2_from_json(input string json_file, output my_struct2_s s);

  initial begin
    begin : simple_struct
      my_struct_s s1;
      populate_struct_from_json("s1.json", s1);
      $display("s1 = %p", s1);
    end

    begin : array_of_structs
      my_struct2_s s2;
      populate_struct2_from_json("s2.json", s2);
      $display("s2 = %p", s2);
    end
  end

endprogram : top
