// Time-stamp: <2023-04-05 10:35:45 kmodi>

`timescale 1ns/1ns

module top();

  parameter SIZE_X = 100;
  parameter SIZE_Y = 10;

  parameter REPEAT = 100_000;          // ~11 seconds
  // parameter REPEAT = 1_000_000;     // ~31 seconds
  // parameter REPEAT = 10_000_000;    // ~241 seconds

  typedef int big_data_2d[SIZE_X][SIZE_Y];

  import "DPI-C" function int f_big_data_2d_nim(input int sizeX, input int sizeY,
`ifdef USE_2D_ARRAY_TYPEDEF
                                                input big_data_2d i, inout big_data_2d io);
  // Tue May 04 08:22:03 EDT 2021 - kmodi
  // Xcelium does not allow 2D arrays on SV/C boundary.
  //                                                   input big_data_2d i, inout big_data_2d io);
  //                                                                     |
  //   xmvlog: *E,UNFRAG (tb.sv,20|66): unsupported datatype in formal argument.
  //                                                   input big_data_2d i, inout big_data_2d io);
  //                                                                                           |
  //   xmvlog: *E,UNFRAG (tb.sv,20|88): unsupported datatype in formal argument.
`else
  // Wed Apr 05 10:27:17 EDT 2023 - kmodi
  // The 2d array typedef 'big_data_2d' used above doesn't compile, but below compiles!
                                                input int i[SIZE_X][SIZE_Y], inout int io[SIZE_X][SIZE_Y]);
`endif // !`ifdef USE_2D_ARRAY_TYPEDEF

  big_data_2d i, io;

  event check_results;

  always @(check_results) begin
    void'(f_big_data_2d_nim(SIZE_X, SIZE_Y, i, io));
  end

  initial begin
    int k;

    foreach (i[x, y]) i[x][y] = k++;
    foreach (io[x, y]) io[x][y] = k++;

    $display("@%t: From SV top (before): i=%p)", $realtime, i);
    $display("@%t: From SV top (before): io=%p)", $realtime, io);

    repeat (REPEAT) begin
      // Perform some fancy algorithm ..
      #1000ns;
      -> check_results;
    end
    #1ns;
    $display("\n\n");
    $display("@%t: From SV top (after): i=%p)", $realtime, i);
    $display("@%t: From SV top (after): io=%p)", $realtime, io);
  end

endmodule : top
