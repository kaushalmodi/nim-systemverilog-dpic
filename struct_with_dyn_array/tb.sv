// Time-stamp: <2019-04-16 17:18:52 kmodi>

program top;

  typedef struct {
    int scalar_int;
    int dyn_arr_int[];
  } my_struct_s;

  import "DPI-C" function void print_object(input my_struct_s s);
  // Cannot pass a dynamic-array containing struct via DPI-C.

  //   import "DPI-C" function void print_object(input my_struct_s s);
  //                                                               |
  // xmvlog: *E,UNUSAG (tb.sv,10|62): unsupported element in unpacked struct datatype in formal argument.

  initial begin
    my_struct_s s;

    s.scalar_int = 100;
    s.dyn_arr_int = '{25, 35, 45};

    $display("Value of the struct printed from SV: %p", s);
    print_object(s);

    $finish;
  end

endprogram : top
