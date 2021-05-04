// Time-stamp: <2021-05-04 12:17:31 kmodi>

`timescale 1ns/1ns

interface recorder();

  typedef struct {
    bit b;
    logic l;
    int i;
    longint li;
  } my_struct_t;

  int an_int;
  my_struct_t s;

  export "DPI-C" function record_an_int;
  export "DPI-C" function record_my_struct;

  function void record_an_int(input int i);
    an_int = i;
  endfunction : record_an_int

  function void record_my_struct(input my_struct_t i);
    s = i;
  endfunction : record_my_struct

endinterface : recorder

module top();

  import "DPI-C" context task run_nim_code1();
  import "DPI-C" context task run_nim_code2();
  import "DPI-C" function void disable_recording();
  import "DPI-C" function void init_rand(input int seed);
  export "DPI-C" task tictoc;

  reg clk;

  recorder u_recorder_1();
  recorder u_recorder_2();

  task tictoc(input int times);
    repeat (times) @(posedge clk);
  endtask : tictoc

  initial begin
    clk = 0;
  end
  always #1ns clk = !clk;

  initial begin
    // Running the SV test with a specific seed with generate a fixed
    // seed passed on to the Nim side too.
    init_rand($urandom_range(1_000_000));
  end

  initial begin
    $timeformat(-9, 3, "ns");  // units, precision, suffix
    $shm_open("waves.shm");
    $shm_probe("ACTM"); // "M" is needed to plot the unpacked arrays like "bit [7:0] unpacked_bytes [4];"
  end

  initial begin
    fork
      // thread # 1
      run_nim_code1();

      // thread # 2
      run_nim_code2();

      // thread # 3
      begin
        #1_000ns;
        disable_recording();
        $finish();
      end
    join
  end // initial begin

endmodule : top
