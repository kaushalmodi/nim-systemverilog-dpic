// Time-stamp: <2019-11-06 21:35:03 kmodi>

`timescale 1ns/1ps

module top;

  import "DPI-C" function void imported_func();

  initial begin
    imported_func();
    $display("Done");

    $finish;
  end

endmodule : top
