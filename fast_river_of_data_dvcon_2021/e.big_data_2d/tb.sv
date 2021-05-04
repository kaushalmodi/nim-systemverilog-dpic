// Time-stamp: <2021-05-04 08:50:41 kmodi>

`timescale 1ns/1ns

module top();

  parameter SIZE_X = 100;
  parameter SIZE_Y = 10;

  parameter REPEAT = 100_000;          // ~11 seconds
  // parameter REPEAT = 1_000_000;     // ~31 seconds
  // parameter REPEAT = 10_000_000;    // ~241 seconds

`ifdef TWO_DIM_ARRAY
  typedef int big_data_2d[SIZE_X][SIZE_Y];

  import "DPI-C" function int f_big_data_2d_nim(input int sizeX, input int sizeY,
                                                input big_data_2d i, inout big_data_2d io);
  // Tue May 04 08:22:03 EDT 2021 - kmodi
  // Xcelium does not allow 2D arrays on SV/C boundary.
  //                                                   input big_data_2d i, inout big_data_2d io);
  //                                                                     |
  //   xmvlog: *E,UNFRAG (tb.sv,20|66): unsupported datatype in formal argument.
  //                                                   input big_data_2d i, inout big_data_2d io);
  //                                                                                           |
  //   xmvlog: *E,UNFRAG (tb.sv,20|88): unsupported datatype in formal argument.

  big_data_2d i, io;
`else // !`ifdef TWO_DIM_ARRAY
  typedef int big_data_2dlike_t[SIZE_X * SIZE_Y];

  import "DPI-C" function int f_big_data_2d_nim(input int size,
                                                input big_data_2dlike_t i, inout big_data_2dlike_t io);

  big_data_2dlike_t i, io;
`endif // !`ifdef TWO_DIM_ARRAY

  event check_results;

  always @(check_results) begin
    void'(f_big_data_2d_nim(SIZE_X * SIZE_Y, i, io));
  end

  initial begin
    int k;

    foreach (i[x]) i[x] = k++;
    foreach (io[x]) io[x] = k++;

    $display("@%t: From SV top (before): i=%p, io=%p)", $realtime, i, io);

    repeat (REPEAT) begin
      // Perform some fancy algorithm ..
      #1000ns;
      -> check_results;
    end
    #1ns;
    $display("@%t: From SV top (after): i=%p, io=%p)", $realtime, i, io);
  end

endmodule : top
