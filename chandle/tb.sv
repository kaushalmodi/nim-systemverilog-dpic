// Time-stamp: <2019-11-08 15:42:11 kmodi>

program top;

  import "DPI-C" getAdderProcHandle = function chandle get_adder_handle();

  // Assume that calling the chandle runs a proc on Nim side that
  // returns an int.
  import "DPI-C" callProc = function int call_int(input chandle ch, int args[]);

  initial begin
    chandle adder_proc_handle; // This is the handle to an adder proc implemented in Nim
    int args[];
    int sum;

    adder_proc_handle = get_adder_handle();

    // args = '{};
    // Above is illegal; args cannot be an empty array.
    // Above will cause this error:
    //   xmsim: *E,MEMALC: Memory not allocated for actual array.
    args = '{100, 200, 300, 400, 500};
    sum = call_int(adder_proc_handle, args);
    $display("Sum of %p = %p", args, sum);

    $finish;
  end

endprogram : top
