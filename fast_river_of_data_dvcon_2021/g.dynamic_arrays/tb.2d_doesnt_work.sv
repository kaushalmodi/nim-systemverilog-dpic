// Time-stamp: <2021-05-04 11:14:34 kmodi>

program top;

  // Lame.. Below does not work:
  // typedef int openarray_2d_t[][];
  // import "DPI-C" function int f_openarray_2d_nim(input openarray_2d_t i,
  //                                                output openarray_2d_t o,
  //                                                inout openarray_2d_t io);
  //
  // Xcelium gives this error:
  //    import "DPI-C" function int f_openarray_2d_nim(input openarray_2d_t i,
  //                                                                        |
  //  xmvlog: *E,UNFRAG (tb.sv,8|70): unsupported datatype in formal argument.
  //                                                   output openarray_2d_t o,
  //                                                                         |
  //  xmvlog: *E,UNFRAG (tb.sv,9|71): unsupported datatype in formal argument.
  //                                                   inout openarray_2d_t io);
  //                                                                         |
  //  xmvlog: *E,UNFRAG (tb.sv,10|71): unsupported datatype in formal argument.
  //
  // But if we manually expand the typedef, Xcelium compiles just fine!
  import "DPI-C" function int f_openarray_2d_nim(input int i[][],
                                                 output int o[][],
                                                 inout int io[][]);

  function void print_openarray_2d(input string name, input int a[][]);
    begin
      $display("%s = %p", name, a);
    end
  endfunction : print_openarray_2d

  initial begin
    int ki, ko, kio;

    for (int cnt = 0; cnt < 10; cnt++) begin
      int i[][], o[][], io[][];
      int X, Y;

      $display("\n=== cnt = %0d ===", cnt);
      X = $urandom_range(10, 5);
      Y = $urandom_range(14, 11);

      i = new[X];
      o = new[X];
      io = new[X];
      for (int x = 0; x < X; x++) begin
        i[x] = new[Y];
        o[x] = new[Y];
        io[x] = new[Y];
      end

      for (int x = 0; x < X; x++) begin
        for (int y = 0; y < Y; y++) begin
          i[x][y] = 12340000 + ki++;
          o[x][y] = 23450000 + ko++;
          io[x][y] = 34560000 + kio++;
        end
      end

      print_openarray_2d("i", i);
      print_openarray_2d("o", o);
      print_openarray_2d("io", io);
      void'(f_openarray_2d_nim(i, o, io));
      // Even with *E,UNFRAG resolved, we get this error here:
      //         void'(f_openarray_2d_nim(i, o, io));
      //                                  |
      //   xmvlog: *E,TYPEERR (tb.sv,65|31): dpi openarray formal and actual do not have supported actual types.
      //         void'(f_openarray_2d_nim(i, o, io));
      //                                  |
      //   xmvlog: *E,TYPEERR (tb.sv,65|31): dpi openarray formal and actual do not have supported actual types.
      //         void'(f_openarray_2d_nim(i, o, io));
      //                                     |
      //   xmvlog: *E,TYPEERR (tb.sv,65|34): dpi openarray formal and actual do not have supported actual types.
      //         void'(f_openarray_2d_nim(i, o, io));
      //                                     |
      //   xmvlog: *E,TYPEERR (tb.sv,65|34): dpi openarray formal and actual do not have supported actual types.
      //         void'(f_openarray_2d_nim(i, o, io));
      //                                         |
      //   xmvlog: *E,TYPEERR (tb.sv,65|38): dpi openarray formal and actual do not have supported actual types.
      //         void'(f_openarray_2d_nim(i, o, io));
      //                                         |
      //   xmvlog: *E,TYPEERR (tb.sv,65|38): dpi openarray formal and actual do not have supported actual types.
    end // for (int cnt = 0; cnt < 10; cnt++)
  end // initial begin

endprogram : top
