// Time-stamp: <2019-01-20 01:45:18 kmodi>
// https://verificationacademy.com/resources/technical-papers/dpi-redux-functionality-speed-optimization

module top();

  export "DPI-C" function sv_print_scope;
  export "DPI-C" task sv_consume_time;

  import "DPI-C" context function int nimAddFunction(input int a, input int b, output int c);
  import "DPI-C" context task nimAddTask (input int a, input int b, output int c);

  function int sv_print_scope(input int value);
    $display("  SV: @%2t: sv_print_scope(): %m [value=%0d]", $time, value);
    return value;
  endfunction

  task sv_consume_time(input int d);
    #d;
  endtask

  initial begin
    int c;
    int ret;
    #10;
    ret = nimAddFunction(10, 20, c);
    nimAddTask(10, 20, c);
  end

endmodule : top
