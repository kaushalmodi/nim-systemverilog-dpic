// Time-stamp: <2021-04-30 23:16:11 kmodi>

program top;

  import "DPI-C" context function logic f_logic_nim(input logic i, output logic o, inout logic io);
  export "DPI-C" function f_logic_sv;

  function logic f_logic_sv(input logic i, output logic o, inout logic io);
    begin
      $display("@%0t: f_logic_sv: Init: i=%0d, o=%0d, io=%0d", $realtime, i, o, io);
      o = io + i; // io is input here
      io = o + 1; // .. and output here
      $display("@%0t: f_logic_sv: i=%0d, o=%0d, io=%0d", $realtime, i, o, io);
      return io + 1;
    end
  endfunction : f_logic_sv

  initial begin
    logic ret, o, io;
    ret = f_logic_nim(1'b0, o, io);
    $display("In SV: f_logic_nim ret = %0d, o = %0d, io = %0d", ret, o, io);
  end

endprogram : top
