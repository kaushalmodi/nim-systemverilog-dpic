// Time-stamp: <2019-03-25 18:56:01 kmodi>

program top;

  export "DPI-C" task FROM_SV_TASK;
  export "DPI-C" function FROM_SV_FUNC;

  import "DPI-C" task TO_SV_TASK(input int in1, in2, output int out);
  import "DPI-C" function void TO_SV_FUNC(input int in1, in2, output int out);

  import "DPI-C" context task TO_SV_TASK_c(input int in1, in2, output int out);
  import "DPI-C" context function void TO_SV_FUNC_c(input int in1, in2, output int out);

  task FROM_SV_TASK(input int in1, in2, output int out);
    $display("Exported from SV task to Nim");
  endtask : FROM_SV_TASK

  function void FROM_SV_FUNC(input int in1, in2, output int out);
    $display("Exported from SV function to Nim");
  endfunction : FROM_SV_FUNC

  initial begin
    int temp;

    TO_SV_TASK(1, 2, temp);
    TO_SV_FUNC(1, 2, temp);

    TO_SV_TASK_c(1, 2, temp);
    TO_SV_FUNC_c(1, 2, temp);

    $finish;
  end

endprogram : top
