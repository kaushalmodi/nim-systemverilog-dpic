// Time-stamp: <2019-05-23 11:58:52 kmodi>
// http://amvrao.blogspot.com/2017/08/good-uses-of-system-verilog-dpi.html
// https://www.edaplayground.com/x/34Wg

module modA
  ( input reg [31:0] startAddr,
    input reg [31:0] endAddr
    );

  //Import the function to register this module..
  int values[int];
  import "DPI-C" context function void registerMe(int startAddr, int endAddr);
  export "DPI-C" function sv_write_reg;

  function void sv_write_reg(int addr, int value);
    values[addr] = value;
    $display("[%t] Write_reg[%m]:: addr=%0d, value=%0d", $realtime, addr, value);
  endfunction : sv_write_reg

  initial begin
    #0; // Necessary otherwise the initial x values of startAddr and endAddr will be passed to registerMe.
    $display("[%t] registerMe[%m](%0d, %0d)", $realtime, startAddr, endAddr);
    registerMe(startAddr, endAddr);
  end

endmodule : modA

module top;
  modA modA1(.startAddr(32'd100), .endAddr(32'd200));
  modA modA2(.startAddr(32'd201), .endAddr(32'd300));
  modA modA3(.startAddr(32'd301), .endAddr(32'd400));
endmodule : top

module test;

  import "DPI-C" context function void nim_write_reg(int addr, int value);

  initial begin
    $timeformat(-9, 3, " ns", 11); // units, precision, suffix_string, minimum_field_width
    #1ns;

    // Now write the registers.
    nim_write_reg(100, 10);
    nim_write_reg(210, 21);
    nim_write_reg(500, 50);

    $finish;
  end

  top t1();
endmodule : test
