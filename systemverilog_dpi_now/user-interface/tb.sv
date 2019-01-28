module top;
  int x, y, m, n, win;
  reg sync_clk;

  real xsq, ysq, tmp, re, im;
  real xr, xincr, yr, yincr;
  real xstart, xend, ystart, yend;

  parameter int num_draws = 5;
  parameter int end_pause = 2000;

  function int get_mandel(input real c_real, input real c_imaginary);
    int i;
    re = 0;
    im = 0;
    for (i = 0; i < 1000; i++) begin
      xsq = (re * re);
      ysq = (im * im);
      if (xsq + ysq > 4.0) break;
      tmp = xsq - ysq + c_real;
      im = 2.0 * re * im + c_imaginary;
      re = tmp;
    end
    if (i == 1000) return 0;
    else           return i;
  endfunction

  task vl_mandel(input int width, input int height,
                 input real xstart, input real xend, input real ystart, input real yend,
                 input int num,
                 input int pause);

    win = draw_init(width, height);
    draw_title(win, "SystemVerilog");

    for (int i=0; i<num; i++) begin
      xincr = (xend - xstart)/width;
      yincr = (yend - ystart)/height;

      yr = ystart;
      for (y = 0; y < height; y++) begin
        hw_sync(1);
        xr = xstart;
        for (x = 0; x < width; x++) begin
          n = get_mandel(xr, yr);
          draw_pixel(win, x, y, n, 1, 1000);
          if ((x % 10) == 0)
            draw_flush(win);
          xr = xr + xincr;
        end
        yr = yr + yincr;
      end
      draw_finish(win);
      hw_sync(pause);
      draw_clear(win);
    end
  endtask

  export "DPI-C" task hw_sync;
  task automatic hw_sync(input int count1);
    while(count1-- > 0) begin @(posedge sync_clk); end
  endtask

  initial begin
    fork
      begin vl_mandel(200, 200, 0.075, 0.175, 0.59, 0.69, num_draws, end_pause); end
      begin  c_mandel(200, 200, 0.075, 0.175, 0.59, 0.69, num_draws, end_pause); end
      begin  c_mandel(100, 100, 0.075, 0.175, 0.59, 0.69, num_draws, end_pause); end
    join
    $finish;
  end

  always begin sync_clk = 0;  #1; sync_clk = 1;  #1; end

  import "DPI-C" context task c_mandel(
                                       input int width,   input int height,
                                       input real xstart, input real xend,
                                       input real ystart, input real yend,
                                       input int num, input int pause);

  import "DPI-C" function void draw_finish(
                                           input int win);
  import "DPI-C" function void draw_flush(
                                          input int win);
  import "DPI-C" function void draw_clear(
                                          input int win);
  import "DPI-C" function void draw_title(
                                          input int win,
                                          input string title);
  import "DPI-C" function int draw_init(
                                        input int width,
                                        input int height);
  import "DPI-C" function void draw_pixel(
                                          input int win,
                                          input int x, input int y, input int n,
                                          input int minlimit, input int maxlimit);
endmodule
