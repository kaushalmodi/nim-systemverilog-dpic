// Time-stamp: <2020-09-18 10:17:27 kmodi>

program top;

  parameter MAX = 10;

  typedef struct {
    bit scalar_bit;
    // cfloat/shortreal in structs is not supported by Xcelium/DPI-C
    //    import "DPI-C" function void print_object(input my_struct_s s);
    //                                                                |
    //  xmvlog: *E,UNUSAG (tb.sv,17|62): unsupported element in unpacked struct datatype in formal argument.
    // shortreal scalar_shortreal;
    real scalar_real;
    int scalar_int;
    int arr_int[MAX];
    // bit arr_bit[MAX]; // xmvlog: *E,UNUSAG (tb.sv,16|62): unsupported element in unpacked struct datatype in formal argument.
    byte unsigned arr_bit[MAX];
  } my_struct_s;

  import "DPI-C" function void print_object(input my_struct_s s);
  import "DPI-C" function void get_object(output my_struct_s s);

  initial begin
    begin
      my_struct_s sa, sb;

      sa.scalar_bit = 1;
      // sa.scalar_shortreal = 0.001; // Not supported
      sa.scalar_real = 1.123;
      sa.scalar_int = 100;
      sa.arr_int = '{ 51, 58, 64, 53, 74, 54, 35, 27, 01, 38 };
      sa.arr_bit = '{ 0, 1, 0, 0, 1, 0, 0, 1, 0, 0 };
      print_object(sa);

      sb.scalar_bit = 0;
      // sa.scalar_shortreal = 9.876; // Not supported
      sb.scalar_real = 8.076;
      sb.scalar_int = 882;
      sb.arr_int = '{ 44, 58, 22, 65, 55, 81, 56, 30, 25, 04 };
      sb.arr_bit = '{ 0, 1, 0, 0, 1, 0, 0, 1, 0, 0 };
      print_object(sb);
    end
    begin
      my_struct_s s;
      get_object(s);
      print_object(s);
    end
    $finish;
  end // initial begin

endprogram : top
