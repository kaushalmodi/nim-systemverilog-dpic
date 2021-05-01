// Time-stamp: <2021-04-30 22:34:11 kmodi>

program top;

  import "DPI-C" context function int f_int_nim(input int i, output int o, inout int io);
  export "DPI-C" function f_int_sv;

  function int f_int_sv(input int i, output int o, inout int io);
    begin
      o = io + i; // io is input here
      io = o + 1; // .. and output here
      $display("@%0t: f_int_sv: i=%0d, o=%0d, io=%0d", $realtime, i, o, io);
      return io + 1;
    end
  endfunction : f_int_sv

  initial begin
    int ret, o, io;
    ret = f_int_nim(100, o, io);
    $display("In SV: f_int_nim ret = %0d, o = %0d, io = %0d", ret, o, io);
  end

endprogram : top
