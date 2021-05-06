`timescale 1ns/1ns
module memory (CLK,RST_B,AD,REQ_B,GNT_B,FRAME_B,CMD,IRDY_B,TRDY_B);
   input CLK,RST_B;
   input [7:0] REQ_B;
   output [7:0] GNT_B;
   reg [7:0] 	GNT_B;
   inout [31:0] AD;
   input 	FRAME_B;
   input 	CMD;
   input 	IRDY_B;
   output 	TRDY_B;
   reg 		TRDY_B;

   reg [31:0] 	AD_reg;
   
   assign AD = AD_reg;
   
   reg [31:0] 	mem[0:'hFFF];
   
   reg [2:0] 	arb;

   function void V_init_mem;
      input 	A;
      input 	D;
      int 	A,D;
      mem[A]=D;
   endfunction : V_init_mem   
   export "DPI-C" function V_init_mem;
      
   always @(posedge CLK or negedge RST_B)
      if (!RST_B)
	 begin
	    arb <=0;
	    GNT_B <= {8{1'b1}};
	 end
      else
	 begin
	    if (FRAME_B)
	       begin : arb_loop
		  // uncommenting one of these lines to change the arbitration
		  //arb= $random; // in random order
		  //arb= arb; // start with the next int the loop
		  //arb= -1; // start back at CPU 0
		  repeat (8)
		     begin
			arb = arb + 1;
			if (REQ_B[arb] == 0)
			   begin
			      GNT_B[arb] <=0;
			      #1 disable arb_loop;
			   end // if (REQ_B[arb] == 0)
		     end // repeat (8)
	       end : arb_loop
	    else
	       begin
		  GNT_B <={8{1'b1}};
	       end // else: !if(FRAME_B)
	 end // else: !if(RST_B)

   integer 	state;
   parameter 	ST_IDLE = 0,
		ST_READ = 1,
		ST_WRITE = 2;
   
   reg [31:0] address;

   always @(posedge CLK or negedge RST_B)
      if (RST_B)
	 case(state)
	   ST_IDLE: begin
	      AD_reg = 32'bz;
	      TRDY_B <= 1;
	      if (!FRAME_B)
		 begin
		    state <= (CMD == 0) ? ST_READ : ST_WRITE;
		    address <= AD;
		 end // if (!FRAME_B)
	   end // case: ST_IDLE
	   ST_READ: begin
	      if (!IRDY_B)
		 begin
		    AD_reg <= mem[address];
		    state <= ST_IDLE;
		    TRDY_B <=0;
		    $display("MEM: %d Read  AD:%h  D:%h at %t",arb,address,mem[address],$realtime);
		 end // if (!IRDY_B)
	   end // case: ST_READ
	   ST_WRITE: begin
	      if (!IRDY_B)
		 begin
		    mem[address] = AD;
		    TRDY_B <=0;
		    state <= ST_IDLE;
		    $display("MEM: %d Write AD:%h  D:%h at %t",arb,address,mem[address],$realtime);
		 end // if (!IRDY_B)
	   end // case: ST_WRITE
	 endcase // case(state)
else
   begin
      state <= ST_IDLE;
      AD_reg <= 32'bz;
      TRDY_B <=1;
   end // else: !if(!IRDY_B)
   

endmodule : memory










