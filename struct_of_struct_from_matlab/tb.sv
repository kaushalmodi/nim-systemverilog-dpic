// Time-stamp: <2019-04-11 11:18:48 kmodi>

program top;

  typedef struct {
    real mean;
    int max;
    int min;
  } struct_elem_s;

  typedef struct {
    struct_elem_s x1;
    struct_elem_s x2;
    struct_elem_s x3;
  } out_struct_wrapper_s;

  typedef int int_arr_3x10 [3][10];

  // Below doesn't work -- Thu Apr 11 10:55:54 EDT 2019 - kmodi
  // import "DPI-C" function void get_params(input int_arr_3x10 in, output out_struct_wrapper_s p);

  // Looks like we cannot pass a 2-D array as input to a function.
  //   import "DPI-C" function void get_params(inout int_arr_3x10 in, output out_struct_wrapper_s p);
  //                                                               |
  // xmvlog: *E,UNFRAG (tb.sv,19|62): unsupported datatype in formal argument.

  // Interestingly, the details for this errors doesn't list a struct
  // type as one of the supported types, but it still is supported.
  // xrun/unfrag =
  //         In the current version of software only int, real, byte, short int, long int ,string  scalar values
  //         of type bit, logic and one dimension packed array of bit and logic, one dimensional open array of
  //         int are supported as function/task argument.

  // So let's try to work around that ..
  typedef struct {
    int_arr_3x10 a;
  } in_struct_wrapper_s;

  import "DPI-C" function void get_params(input in_struct_wrapper_s in_str, output out_struct_wrapper_s out_str);

  initial begin
    in_struct_wrapper_s inp;
    out_struct_wrapper_s outp;
    int_arr_3x10 vals;

    vals = '{ { 632, 68, 87, 73, 22, 63, 20, 04, 88, 85 },
              { 104, 36, 53, 35, 00, 36, 51, 73, 74, 08 },
              { 080, 83, 60, 66, 77, 50, 40, 64, 07, 24 } };
    inp.a = vals;

    get_params(inp, outp);
    $display("Input struct = %p", inp);
    $display("Calculated params from that struct = %p", outp);

    $finish;
  end

endprogram : top
