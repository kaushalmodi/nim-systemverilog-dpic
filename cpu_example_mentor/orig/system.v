//
// -------------------------------------------------------------
//    Copyright 2011 Mentor Graphics, Inc.
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//
`timescale 1 ns /1 ns
module system;
  reg clk,rstb;
  wire [31:0] AD;
  wire [7:0]  REQ_B,GNT_B;
  tri1        FRAME_B,CMD,IRDY_B,TRDY_B;

  task V_posedge;
    @(posedge clk);
  endtask : V_posedge

  export "DPI-C" task V_posedge;

  memory m1(clk,rstb,AD,REQ_B,GNT_B,FRAME_B,CMD,IRDY_B,TRDY_B);

  risc #0 cpu0(clk,rstb,AD,REQ_B[0],GNT_B[0],FRAME_B,CMD,IRDY_B,TRDY_B);
  risc #1 cpu1(clk,rstb,AD,REQ_B[1],GNT_B[1],FRAME_B,CMD,IRDY_B,TRDY_B);
  dsp2 #2 cpu2(clk,rstb,AD,REQ_B[2],GNT_B[2],FRAME_B,CMD,IRDY_B,TRDY_B);
  dsp3 #3 cpu3(clk,rstb,AD,REQ_B[3],GNT_B[3],FRAME_B,CMD,IRDY_B,TRDY_B);
  risc #4 cpu4(clk,rstb,AD,REQ_B[4],GNT_B[4],FRAME_B,CMD,IRDY_B,TRDY_B);
  risc #5 cpu5(clk,rstb,AD,REQ_B[5],GNT_B[5],FRAME_B,CMD,IRDY_B,TRDY_B);
  risc #6 cpu6(clk,rstb,AD,REQ_B[6],GNT_B[6],FRAME_B,CMD,IRDY_B,TRDY_B);
  risc #7 cpu7(clk,rstb,AD,REQ_B[7],GNT_B[7],FRAME_B,CMD,IRDY_B,TRDY_B);

  always
    begin
      #5 clk = 0;
      #5 clk = 1;
    end // always begin
  initial
    begin
      $timeformat(-9,0," ns");
      rstb = 0;
      @(posedge clk)
        rstb = 1;
      fork
        begin : wait_cpu0_halt
          wait(cpu0.halt);
          $display("End of Run at %t",$time);
          $finish;
        end // fork begin
        begin : simulation_timeout
          #20000;
          $display("Simulation Timeout");
          $finish;
        end
      join
    end

endmodule : system
