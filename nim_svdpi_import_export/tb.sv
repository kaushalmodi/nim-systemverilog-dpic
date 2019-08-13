module top();

  export "DPI-C" function sv_print_scope;
  export "DPI-C" task sv_consume_time;

  import "DPI-C" context function void addFunction(input int a, input int b, output int c);
  import "DPI-C" context task addTask (input int a, input int b, output int c);

  function int sv_print_scope(input int value);
    $display("SV: @%2t: sv_print_scope(): %m [value=%0d]", $realtime, value);
    return value;
  endfunction

  task sv_consume_time(input int delay);
    #delay;
  endtask

  initial begin
    int c;
    $timeformat(-9, 0, "ns", 13);
    #20;
    addTask(10, 20, c);
    addFunction(30, 40, c);
    #3;
    $finish;
  end

endmodule : top
