// Time-stamp: <2021-05-03 21:12:23 kmodi>

`timescale 1ns/1ns

program top;

  import "DPI-C" context task t_int_nim(input string threadname,
                                        input int i, output int o, inout int io);
  export "DPI-C" task t_int_sv;

  task automatic t_int_sv(input string threadname,
                          input int i, output int o, inout int io);
    begin
      $display("@%0t: %s:: Entering t_int_sv", $realtime, threadname);
      o = i + 1;
      io = o + 1;
      #10ns;
    end
  endtask : t_int_sv

  initial begin : thread_1
    int i, o, io;
    string threadname;
    threadname = "thread 1";
    i = 10;
    o = 100;
    io = 1000;
    #5ns; // Arbitrarily set delay
    t_int_nim(threadname, i, o, io);
    $display("@%0t: %s:: After t_int_nim call: i=%0d, o=%0d, io=%0d)", $realtime, threadname, i, o, io);
  end

  initial begin : thread_2
    int i, o, io;
    string threadname;
    threadname = "thread 2";
    i = 20;
    o = 200;
    io = 2000;
    t_int_nim(threadname, i, o, io);
    $display("@%0t: %s:: After t_int_nim call: i=%0d, o=%0d, io=%0d)", $realtime, threadname, i, o, io);
  end

endprogram : top
