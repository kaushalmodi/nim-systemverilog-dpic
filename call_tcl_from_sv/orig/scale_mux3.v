`timescale 1ns / 100ps
module scale_mux3(out, a, b, sel);
// `include "params.v"
parameter width=1;
output [width-1:0] out;
input [width-1:0] a,b;
input sel;

// reg [width-1:0] out;

assign out = ( sel == 'b0) ? a : ( sel == 'b1) ? b : {width{1'bx}};
initial $display("\n\t executing scale_mux3 \n");


endmodule
