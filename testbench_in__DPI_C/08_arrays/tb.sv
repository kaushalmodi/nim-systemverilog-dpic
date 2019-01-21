// Time-stamp: <2019-01-21 12:38:49 kmodi>
// http://www.testbench.in/DP_08_ARRAYS.html

program main;

  import "DPI-C" context function void pass_int_array (input int dyn_arr[]); // passing open array dyn_arr[]
  // http://geekwentfreak.com/posts/eda/SystemVerilog_C_pass_datatypes/
  import "DPI-C" function void add_lpv (input logic [3:0] a, b, output logic [3:0] c); // passing logic packed vectors
  import "DPI-C" function void get_nums (output logic [15:0] nums [10]); // passing packed logic array [15:0] nums [10]The
  import "DPI-C" function void get_nums2 (output logic [15:0] nums [10]);
  import "DPI-C" function void get_nums3 (output logic [15:0] nums [10]);

  int fxd_arr_1 [3:8];
  int fxd_arr_2 [12:1];

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

    // Packed vectors example
    begin
      logic [3:0] a, b, c;
      a = 4'd1;
      b = 4'd3;
      add_lpv(a, b, c);
      $display("after add_lpv: %0d + %0d = %0d", a, b, c);
    end

    // Packed array example
    get_nums(nums);
    foreach (nums[i]) begin
      $display("  SV: nums[%0d] = %0d", i, nums[i]);
    end
    // Note: calling get_nums multiple times or even its variants that
    // update nums2, nums3, etc. causes SIGSEGV fault, unless nim is
    // compiled with --gc:none.
    get_nums2(nums2);
    foreach (nums2[i]) begin
      $display("  SV: nums2[%0d] = %0d", i, nums2[i]);
    end
    get_nums3(nums3);
    foreach (nums3[i]) begin
      $display("  SV: nums3[%0d] = %0d", i, nums3[i]);
    end

    $finish;
  end
endprogram : main
