// Time-stamp: <2019-01-20 22:00:58 kmodi>
// http://www.testbench.in/DP_05_EXPORT.html

program main;

  export "DPI-C" function export_func;
  export "DPI-C" task export_task;
  import "DPI-C" context function void import_func();
  //             ^^^^^^^
  // Without the above 'context' keyword, you get an error like:
  // xmsim: *E,NONCONI: The C identifier "export_func" representing an
  // export task/function cannot be executed from a non-context import
  // task/function.
  import "DPI-C" context task import_task();

  function void export_func();
    $display("Hello from SV");
  endfunction

  task export_task();
    $display("SV: [%0t] Entered the export function .. wait for some time", $time);
    #100;
    $display("SV: [%0t] After waiting", $time);
  endtask

  initial begin
    $timeformat(-9, 3, "ns");  // units, precision, suffix
    $display("SV: [%0t] Before calling import function", $time);
    import_func();
    $display("SV: [%0t] After calling import function", $time);

    $display("SV: [%0t] Before calling import task", $time);
    import_task();
    $display("SV: [%0t] After calling import task", $time);
  end

endprogram
