// Time-stamp: <2019-01-20 22:33:02 kmodi>

program top;

  // * Neither sending nor receiving variables between SystemVerilog and C
  import "DPI-C" hello = function void hello_func();
  import "DPI-C" hello = task hello_task();

  initial begin
    hello_func();
    hello_task();
    $display("");
    $finish;
  end
endprogram

  // https://github.com/grg/verilator/blob/master/include/vltstd/svdpi.h
  // https://www.doulos.com/knowhow/sysverilog/tutorial/dpi/
  // http://www.project-veripage.com/dpi_tutorial_1.php
