// Time-stamp: <2019-03-18 22:50:11 kmodi>
// http://www.testbench.in/DP_08_ARRAYS.html

program main;

  import "DPI-C" context function void pass_int_array (input int dyn_arr[]); // passing open array dyn_arr[]
  // http://geekwentfreak.com/posts/eda/SystemVerilog_C_pass_datatypes/
  import "DPI-C" function void add_lpv (input logic [3:0] a, b, output logic [3:0] c); // passing logic packed vectors
  import "DPI-C" function void get_nums_var_arg (output logic [15:0] nums [10]); // passing packed logic array [15:0] nums [10]The
  import "DPI-C" function void get_nums_ref_arg1 (output logic [15:0] nums [10]);
  import "DPI-C" function void get_nums_ref_arg2 (output logic [15:0] nums [10]);

  int fxd_arr_1 [3:8];
  int fxd_arr_2 [12:1];
  int fxd_arr_3 [9:9];

  logic [15:0] nums [10];
  logic [15:0] nums2 [10];
  logic [15:0] nums3 [10];

  initial begin
    // Open array example
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

    for (int i=9; i<=9; i++)
      begin
        fxd_arr_3[i] = $random();
        $display("SV: fxd_arr_3[%0d]: %d",i, fxd_arr_3[i]);
      end
    $display("\n Passing fxd_arr_3 to C \n");
    pass_int_array(fxd_arr_3);

    // Packed vectors example
    begin
      logic [3:0] a, b, c;
      a = 4'd1;
      b = 4'd3;
      add_lpv(a, b, c);
      $display("after add_lpv: %0d + %0d = %0d", a, b, c);
    end

    // Packed array example
    get_nums_var_arg(nums);
    foreach (nums[i]) begin
      $display("  SV: nums[%0d] = %0d", i, nums[i]);
    end
    // Note: calling get_nums_var_arg multiple times or even its
    // variants that update nums2, nums3, etc. causes SIGSEGV fault,
    // unless nim is compiled with --gc:none or --gc:regions.
    get_nums_ref_arg1(nums2);
    foreach (nums2[i]) begin
      $display("  SV: nums2[%0d] = %0d", i, nums2[i]);
    end
    get_nums_ref_arg2(nums3);
    foreach (nums3[i]) begin
      $display("  SV: nums3[%0d] = %0d", i, nums3[i]);
    end

    $finish;
  end
endprogram : main
