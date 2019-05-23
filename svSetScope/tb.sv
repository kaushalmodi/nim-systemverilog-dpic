// Time-stamp: <2019-05-23 11:00:30 kmodi>
// https://verificationacademy.com/forums/systemverilog/how-bind-dpi-files-and-testbench-files#answer-45143

module tbench;

  export "DPI-C" task dpisv_RegRead32;

  task dpisv_RegRead32(input int unsigned offset, output int unsigned data);
    begin
      $display("[%t] dpisv_RegRead32", $realtime);
      data = 32'h1000; // data I have hardcoded but needs to be picked from SV TB
      #20ns;
    end
  endtask : dpisv_RegRead32

  initial begin
    $timeformat(-9, 3, " ns", 11); // units, precision, suffix_string, minimum_field_width

    setup_complete();
    #1000ns;
    $finish();
  end

endmodule : tbench

module reftb_dpi;
  tbench tbench_i();  // instantiated the tbench

  import "DPI-C" context task doTest(input int unsigned offset, output int unsigned data);
  //               ^
  //               |
  //         If this "context" keyword is absent, we get these errors:
  // xmsim: *E,NOCONTI: DPI Scope function call is not
  //   allowed from non-context function: doTest, file name:
  //   /path/to/current/dir/tb.sv, at line no:35.
  // xmsim: *E,NOCONTI: DPI Scope function call is not
  //   allowed from non-context function: doTest, file name:
  //   /path/to/current/dir/tb.sv, at line no:35.
  // xmsim: *E,NONCONI: The C identifier "dpisv_RegRead32"
  //   representing an export task/function cannot be executed
  //   from a non-context import task/function : doTest file name:
  //   /path/to/current/dir/tb.sv, line: 35.
  int unsigned data;

  task setup_complete ();
    begin
      $display("[%t] platform_setup_complete is called", $realtime);
      doTest(1, data);
    end
  endtask : setup_complete
endmodule : reftb_dpi
