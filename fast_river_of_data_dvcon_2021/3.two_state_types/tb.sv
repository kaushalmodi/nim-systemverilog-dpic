// Time-stamp: <2021-04-30 22:44:58 kmodi>

program top;

  import "DPI-C" context function bit f_bit_nim(input bit i, output bit o, inout bit io);
  export "DPI-C" function f_bit_sv;

  function bit f_bit_sv(input bit i, output bit o, inout bit io);
    begin
      o = io + i; // io is input here
      io = o + 1; // .. and output here
      $display("@%0t: f_bit_sv: i=%0d, o=%0d, io=%0d", $realtime, i, o, io);
      return io + 1;
    end
  endfunction : f_bit_sv

  initial begin
    bit ret, i, o, io;
    i = 1;
    o = 1;
    io = 1;
    ret = f_bit_nim(i, o, io);
    $display("In SV: f_bit_nim ret = %0d, i = %0d, o = %0d, io = %0d", ret, i, o, io);
  end

endprogram : top
