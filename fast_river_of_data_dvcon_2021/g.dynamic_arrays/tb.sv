// Time-stamp: <2021-05-04 11:29:02 kmodi>

program top;

  parameter MAX_CNT = 3;

  import "DPI-C" function int f_openarray_1d_nim(input int i[],
                                                 output int o[],
                                                 inout int io[]);

  initial begin
    int ki, ko, kio;

    for (int cnt = 0; cnt < MAX_CNT; cnt++) begin
      int i[], o[], io[];
      int X;

      $display("\n=== cnt = %0d ===", cnt);
      X = $urandom_range(10, 5);

      i = new[X];
      o = new[X];
      io = new[X];

      for (int x = 0; x < X; x++) begin
        i[x] = 12340000 + ki++;
        o[x] = 23450000 + ko++;
        io[x] = 34560000 + kio++;
      end

      $display("from SV: before: i = %p", i);
      $display("from SV: before: o = %p", o);
      $display("from SV: before: io = %p", io);
      void'(f_openarray_1d_nim(i, o, io));
      $display("from SV: after: i = %p", i);
      $display("from SV: after: o = %p", o);
      $display("from SV: after: io = %p", io);
    end // for (int cnt = 0; cnt < MAX_CNT; cnt++)
  end // initial begin

endprogram : top
