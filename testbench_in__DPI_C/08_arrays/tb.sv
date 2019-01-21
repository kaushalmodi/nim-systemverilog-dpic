// Time-stamp: <2019-01-21 09:25:09 kmodi>
// http://www.testbench.in/DP_08_ARRAYS.html

program main;

  import "DPI-C" context function void pass_int_array (input int dyn_arr[]);

  int fxd_arr_1 [3:8];
  int fxd_arr_2 [12:1];

  initial begin
    for (int i=3; i<=8; i++)
      begin
        fxd_arr_1[i] = $random();
        $display("SV: fxd_arr_1[%0d]: %d",i, fxd_arr_1[i]);
      end

    $display("\n Passing fxd_arr_1 to C \n");
    pass_int_array(fxd_arr_1);

    for (int i=1; i<=12; i++)
      begin
        fxd_arr_2[i] = $random();
        $display("SV: fxd_arr_2[%0d]: %d",i, fxd_arr_2[i]);
      end

    $display("\n Passing fxd_arr_2 to C \n");
    pass_int_array(fxd_arr_2);

    $finish;
  end
endprogram : main
