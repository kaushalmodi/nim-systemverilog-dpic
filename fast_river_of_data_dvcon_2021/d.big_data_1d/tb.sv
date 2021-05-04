// Time-stamp: <2021-05-04 02:16:38 kmodi>

`timescale 1ns/1ns

program top;

  parameter SIZE = 1_000;

  parameter REPEAT = 100_000;          // ~7 seconds
  // parameter REPEAT = 1_000_000;     // ~29 seconds
  // parameter REPEAT = 10_000_000;    // ~250 seconds

  typedef int big_data_t [SIZE];

  import "DPI-C" function int f_big_data_nim(input int size, input big_data_t i, inout big_data_t io);

  big_data_t i, io;

  initial begin
    repeat (REPEAT) begin
      void'(f_big_data_nim(SIZE, i, io));
      #10ns;
    end
  end

endprogram : top
