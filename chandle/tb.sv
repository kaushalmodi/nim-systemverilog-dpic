// Time-stamp: <2019-11-08 15:55:48 kmodi>

program top;

  import "DPI-C" getAdderProcHandleInt = function chandle get_adder_handle_int();
  import "DPI-C" callProcInt = function int call_int(input chandle ch, int args[]);

  initial begin

    begin : chandle_to_int_proc
      chandle adder_ch; // This is the handle to an adder proc implemented in Nim
      int args[];
      int sum;

      adder_ch = get_adder_handle_int();

      // args = '{};
      // Above is illegal; args cannot be an empty array.
      // Above will cause this error:
      //   xmsim: *E,MEMALC: Memory not allocated for actual array.
      args = '{100, 200, 300, 400, 500};
      sum = call_int(adder_ch, args);
      $display("Sum of %p = %p", args, sum);
    end : chandle_to_int_proc

    $finish;
  end

endprogram : top
