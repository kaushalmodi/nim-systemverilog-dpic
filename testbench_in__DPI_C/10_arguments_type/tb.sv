// Time-stamp: <2019-01-21 17:47:01 kmodi>
// http://www.testbench.in/DP_09_PASSING_STRUCTS_AND_UNIONS.html

program main;

  string str_to_nim, str_from_nim;

  import "DPI-C" task string_sv2nim(string str);
  import "DPI-C" function string string_nim2sv();

  initial begin
    str_to_nim = "HELLO: This string is created in SystemVerilog\n";
    string_sv2nim(str_to_nim);

    str_from_nim = string_nim2sv();
    $display("  SV: %s", str_from_nim);

    $finish;
  end

endprogram : main
