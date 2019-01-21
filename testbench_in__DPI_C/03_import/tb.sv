// Time-stamp: <2019-01-20 21:43:27 kmodi>
// http://www.testbench.in/DP_03_IMPORT.html

program main;
  string str;

  import "DPI-C" string_sv2nim=task string_sv2nim();

  initial begin
    string_sv2nim();
  end

endprogram
