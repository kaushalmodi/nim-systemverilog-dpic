`timescale 1ns / 10ps

`define TOP_NAME "test"

module test;

  import "DPI-C" function void call_tcl(string s);
  import "DPI-C" function void get_tcl_output(string cmd, output string out[]);

  parameter WIDTH = 8;

  reg [WIDTH-1:0] a, b;
  reg sel;
  wire [WIDTH-1:0] out1;
  wire [WIDTH-1:0] out2;
  wire [WIDTH-1:0] out3;

  scale_mux1 #(WIDTH) u1 (out1, a, b, sel);
  //    defparam u1.width = WIDTH;

  scale_mux2 u2 (out2, a, b, sel);
  defparam u2.width = WIDTH;

  scale_mux3 u3 (out3, a, b, sel);
  defparam u3.width = WIDTH;

  // array_mux3 u[WIDTH:0] (out4, a, b, sel);
  //    defparam u3.width = 1;

  initial begin
    a =0; b=0; sel=0;
    #10 a = 1;
    #10 sel = 1;
    #10 a = 12;
    #10 sel = 0;
    #10 sel = 'bZ;
    b = 'h1f;
    #10 sel = 1;
    #20 $finish;
  end

  initial begin
    logic somevar;

    begin : print_all_instances_in_scope
      string tcl_cmd;
      string tcl_outputs[];

      tcl_outputs = new[4]; // Assume that the tcl call returns 4 elements
      tcl_cmd = $sformatf("find -scope %s -instances -recursive *", `TOP_NAME);

      $display("Calling `%s' ..", tcl_cmd);
      get_tcl_output(tcl_cmd, tcl_outputs);
      $display("output: %p", tcl_outputs);
    end : print_all_instances_in_scope

    $display("%0t ns: Opening database ", $realtime);
    call_tcl("database -open -default -shm waves.shm");

    begin : probe_all
      string prb_cmd;
      #1; // delaying the probe will cause a 1 unit gap in waveform at the beginning
      prb_cmd = $sformatf("probe %s -all -depth all -dynamic", `TOP_NAME);
      call_tcl(prb_cmd);
    end

    #5;
    somevar = 1'b0;

    #5;
    somevar = 1'b1;

    #5;
    somevar = 1'bz;
  end

endmodule : test
