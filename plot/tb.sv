// Time-stamp: <2019-11-04 11:42:53 kmodi>

`timescale 1ns/1ps

module top;

  parameter DYN_ARR_SIZE = 10_000;

  typedef struct {
    real x;
    real y;
  } xy_s;

  typedef struct {
    int unsigned width_pixels;
    int unsigned height_pixels;
    string title;
    string file_path;
    real x_min;
    real x_max;
    real y_min;
    real y_max;
    real x_tic;
    real y_tic;
  } plot_options_s;

  import "DPI-C" pure function real atan  (input real rTheta);

  import "DPI-C" function void plot(input int unsigned num_elems, xy_s s[], plot_options_s options);

  const real PI = atan(1)*4;

  bit clk;
  int unsigned cnt;
  real sin;
  xy_s dyn_arr[];

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
    plot_options_s options;

    #3ns;

    options = '{
                 width_pixels: 720, // optional
                 height_pixels: 480, // optional
                 title: "Sine tone", // optional
                 // file_path: "plot.png", // optional
                 x_min: 0,
                 x_max: cnt+1,
                 y_min: -1.0,
                 y_max: 1.0,
                 x_tic: 200,
                 y_tic: 0.1,
                 default: 0
                 };
    plot(cnt, dyn_arr, options);
    $finish;
  end

  initial begin
    $timeformat(-9, 3, "ns");  // units, precision, suffix
    $shm_open("waves.shm");
    $shm_probe("ACTM"); // "M" is needed to plot the unpacked arrays like "bit [7:0] unpacked_bytes [4];"
  end

endmodule : top
