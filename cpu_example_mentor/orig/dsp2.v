`timescale 1ns/1ns

module dsp2 (CLK,RST_B,AD,REQ_B,GNT_B,FRAME_B,CMD,IRDY_B,TRDY_B);
  input CLK,RST_B,GNT_B,TRDY_B;
  output REQ_B,FRAME_B,IRDY_B;
  reg    REQ_B,FRAME_B,IRDY_B;
  inout [31:0] AD;
  output   CMD;
  reg      CMD;
  reg [31:0]   AD_reg;

  parameter ID = 0;

  assign AD = AD_reg;

  initial
    wait(RST_B)
      C_dsp(ID);

  import "DPI-C" context task C_dsp (input int);

  export "DPI-C" task V_read;
  export "DPI-C" task V_write;

  export "DPI-C" task V_posedge;

  task V_posedge;
    @(posedge CLK);
  endtask : V_posedge

  task V_read;
    input  address;
    output data;
    int    address,data;

    begin
      REQ_B <= 0;
      wait(!GNT_B);
      REQ_B <= 1;
      FRAME_B <= 0;
      CMD <= 0;
      AD_reg <= address;
      @(posedge CLK)
        AD_reg <= 32'bz;
      IRDY_B <=0;
      wait(!TRDY_B);
      data = AD;
      IRDY_B <=1'bz;
      FRAME_B <= 1'bz;
      CMD <= 1'bz;
    end
  endtask

  task V_write;
    input address;
    input data;
    int   address,data;

    begin
      REQ_B <= 0;
      wait(!GNT_B);
      REQ_B <= 1;
      FRAME_B <= 0;
      CMD <= 1;
      AD_reg <= address;
      @(posedge CLK)
        AD_reg <= data;
      IRDY_B <=0;
      wait(!TRDY_B);
      AD_reg = 32'bz;
      IRDY_B <=1'bz;
      FRAME_B <= 1'bz;
      CMD <= 1'bz;
    end
  endtask

  initial
    begin
      AD_reg =32'bz;
      IRDY_B <=1'bz;
      FRAME_B <= 1'bz;
      CMD <= 1'bz;
      REQ_B <= 1;
    end // initial begin

endmodule
