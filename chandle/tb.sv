// Time-stamp: <2019-11-08 16:16:30 kmodi>

program top;

  import "DPI-C" getAdderProcHandleInt = function chandle get_adder_handle_int();
  import "DPI-C" callProcInt = function int call_int(input chandle ch, int args[]);

  import "DPI-C" getAdderProcHandleFloat = function chandle get_adder_handle_real();
  import "DPI-C" callProcFloat = function real call_real(input chandle ch, real args[]);

  import "DPI-C" getAdderProcHandleString = function chandle get_adder_handle_string();
  import "DPI-C" callProcString = function string call_string(input chandle ch, string args[]);

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
      $display("Int sum of %p = %p", args, sum);
    end : chandle_to_int_proc

    begin : chandle_to_real_proc
      chandle adder_ch; // This is the handle to an adder proc implemented in Nim
      real args[];
      real sum;

      adder_ch = get_adder_handle_real();

      args = '{4.5, 61.7, 1.44, 48.6, 0.213};
      sum = call_real(adder_ch, args);
      $display("Real sum of %p = %p", args, sum);
    end : chandle_to_real_proc

    begin : chandle_to_string_proc
      chandle adder_ch; // This is the handle to an adder proc implemented in Nim
      string args[];
      string sum;

      adder_ch = get_adder_handle_string();

      args = '{"You", "are", "seeing", "the", "magic", "of", "Nim", "generics!"};
      sum = call_string(adder_ch, args);
      $display("String sum of %p = %p", args, sum);
    end : chandle_to_string_proc

    $finish;
  end

endprogram : top
