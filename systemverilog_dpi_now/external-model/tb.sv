module top;
  reg clk;
  shortint expected_data, observed_data;

  import "DPI-C" context task c_store(input int addr, input shortint data);

  // return output from C
  import "DPI-C" context task c_retrieve(input int addr, output shortint data);

  // Can't be a function -> consumes time.
  export "DPI-C" task vl_posedge_clk;
  task vl_posedge_clk();
    @(posedge clk);
  endtask

  initial begin
    expected_data = 1024;
    c_store(100, expected_data);
    c_retrieve(100, observed_data);
    $display("Mem[100]=%d", observed_data);
    assert (observed_data == expected_data);

    $finish;
  end

  always begin
    clk = 0; #50; clk = 1; #50;
  end
endmodule
