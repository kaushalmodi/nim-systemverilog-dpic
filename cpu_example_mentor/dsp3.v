module dsp3 (
             input  bit CLK, RST_B,
             inout  wire [31:0] AD,
             output logic REQ_B,
             input  wire GNT_B,
             output logic FRAME_B, CMD, IRDY_B,
             input  wire  TRDY_B);


  parameter int DSP_begin = 1;
  parameter int DSP_end = -1;
  parameter int DSP_flag = 'h220;
  parameter int DSP_A  = 'h221;
  parameter int DSP_B  = 'h223;
  parameter int DSP_X  = 'h225;

  typedef struct {
    int r;
    int i;
  } complex;



  logic [31:0]    AD_reg;

  assign AD = AD_reg;

  parameter   ID = 0;

  always begin
    wait(RST_B)
      fork
        wait_for_reset: wait(!RST_B);
        main : begin
          repeat(10)
            @(posedge CLK);
          forever
            begin : loop
              automatic int flag = 0;
              complex Local_A;
              complex Local_B;
              complex Local_X;
              while (flag != DSP_begin)
                V_read(DSP_flag, flag);
              // Get A and B operands
              V_read(DSP_A, Local_A.r);
              V_read(DSP_A+1, Local_A.i);
              V_read(DSP_B, Local_B.r);
              V_read(DSP_B+1, Local_B.i);

              // your algorithm here
              Local_X.r = (Local_A.r * Local_B.r) - (Local_A.i * Local_B.i);
              Local_X.i = (Local_A.r * Local_B.r) + (Local_A.i * Local_B.i);

              // Delay result by expected number of instructions
              repeat(2*Local_A.r)
                @(posedge CLK);
              // Save result
              V_write(DSP_X,Local_X.r);
              V_write(DSP_X+1,Local_X.i);
              V_write(DSP_flag,DSP_end);
            end : loop
        end : main
      join_any
    disable fork;
  end // always begin

  task V_read(  input integer address,
                output integer data);
    REQ_B <= 0;
    wait(!GNT_B);
    REQ_B <= 1;
    FRAME_B <= 0;
    CMD <= 0;
    AD_reg <= address;
    @(posedge CLK)
      AD_reg <= 'z;
    IRDY_B <=0;
    wait(!TRDY_B);
    data = AD;
    IRDY_B <='z;
    FRAME_B <= 'z;
    CMD <= 'z;
  endtask : V_read

  task V_write( input integer address, data);
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
    AD_reg = 'z;
    IRDY_B <='z;
    FRAME_B <= 'z;
    CMD <= 'z;
  endtask : V_write

  initial
    begin
      AD_reg ='z;
      IRDY_B ='z;
      FRAME_B = 'z;
      CMD = 'z;
      REQ_B = 1;
    end // initial begin

endmodule : dsp3
