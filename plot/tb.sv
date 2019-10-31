// Time-stamp: <2019-10-31 01:47:34 kmodi>

`timescale 1ns/1ps

module top;

  parameter DYN_ARR_SIZE = 10_000;

  typedef struct {
    int unsigned cnt;
    real sin;
  } my_struct_s;

  import "DPI-C" pure function real atan  (input real rTheta);

  import "DPI-C" function void plot(input int unsigned num_elems, my_struct_s s[], string file_name);

  const real PI = atan(1)*4;

  bit clk;
  int unsigned cnt;
  real sin;
  my_struct_s dyn_arr[];

  initial begin
    dyn_arr = new[DYN_ARR_SIZE];
  end

  always #1ps clk = ~clk;

  always @ (posedge clk) begin
    sin = $sin(0.01*2*PI*cnt);
    dyn_arr[cnt] = '{cnt, sin};
    cnt++;
  end

  initial begin

    #5ns;

    plot(cnt, dyn_arr, "plot.png");
    $finish;
  end

  initial begin
    $timeformat(-9, 3, "ns");  // units, precision, suffix
    $shm_open("waves.shm");
    $shm_probe("ACTM"); // "M" is needed to plot the unpacked arrays like "bit [7:0] unpacked_bytes [4];"
  end

endmodule : top
