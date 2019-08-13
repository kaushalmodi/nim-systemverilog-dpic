// Time-stamp: <2019-08-13 09:14:09 kmodi>
// https://verificationacademy.com/resources/technical-papers/dpi-redux-functionality-speed-optimization

module top();

  export "DPI-C" function sv_print_scope;
  export "DPI-C" task sv_consume_time;

  import "DPI-C" context function int addFunction(input int a, input int b, output int c);
  import "DPI-C" context task addTask (input int a, input int b, output int c);

  function int sv_print_scope(input int value);
    $display("  SV: @%2t: sv_print_scope(): %m [value=%0d]", $time, value);
    return value;
  endfunction

  task sv_consume_time(input int delay);
    #delay;
  endtask

  initial begin
    int c;
    int ret;
    #10;
    ret = addFunction(10, 20, c);
    addTask(30, 40, c);
    $finish;
  end

endmodule : top
