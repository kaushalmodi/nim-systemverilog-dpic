// Time-stamp: <2019-11-11 11:52:57 kmodi>

program top;

  typedef enum { nimAdder, nimSubber } nim_proc_e;

  import "DPI-C" getProcHandleInt = function chandle get_handle_int(input nim_proc_e fn_enum);
  import "DPI-C" callProcInt = function int call_int(input chandle ch, nim_proc_e fn_enum, int args[]);

  import "DPI-C" getProcHandleFloat = function chandle get_handle_real(input nim_proc_e fn_enum);
  import "DPI-C" callProcFloat = function real call_real(input chandle ch, nim_proc_e fn_enum, real args[]);

  import "DPI-C" getProcHandleString = function chandle get_handle_string(input nim_proc_e fn_enum);
  import "DPI-C" callProcString = function string call_string(input chandle ch, nim_proc_e fn_enum, string args[]);

  initial begin

    begin : chandle_to_int_adder_proc
      chandle adder_ch; // This is the handle to an adder proc implemented in Nim
      int args[];
      int sum;

      adder_ch = get_handle_int(nimAdder);

      // args = '{};
      // Above is illegal; args cannot be an empty array.
      // Above will cause this error:
      //   xmsim: *E,MEMALC: Memory not allocated for actual array.
      args = '{100, 200, 300, 400, 500};
      sum = call_int(adder_ch, nimAdder, args);
      $display("Int sum of %p = %p", args, sum);
    end : chandle_to_int_adder_proc

    begin : chandle_to_real_adder_proc
      chandle adder_ch; // This is the handle to an adder proc implemented in Nim
      real args[];
      real sum;

      adder_ch = get_handle_real(nimAdder);

      args = '{4.5, 61.7, 1.44, 48.6, 0.213};
      sum = call_real(adder_ch, nimAdder, args);
      $display("Real sum of %p = %p", args, sum);
    end : chandle_to_real_adder_proc

    begin : chandle_to_string_adder_proc
      chandle adder_ch; // This is the handle to an adder proc implemented in Nim
      string args[];
      string sum;

      adder_ch = get_handle_string(nimAdder);

      args = '{"You", "are", "seeing", "the", "magic", "of", "Nim", "generics!"};
      sum = call_string(adder_ch, nimAdder, args);
      $display("String sum of %p = %p", args, sum);
    end : chandle_to_string_adder_proc

    begin : chandle_to_int_subber_proc
      chandle subber_ch; // This is the handle to an subber proc implemented in Nim
      int args[];
      int res;

      subber_ch = get_handle_int(nimSubber);

      args = '{100, 200, 300, 400, 500};
      res = call_int(subber_ch, nimSubber, args);
      $display("Int result of %p = %p", args, res);
    end : chandle_to_int_subber_proc

    begin : chandle_to_real_subber_proc
      chandle subber_ch; // This is the handle to an subber proc implemented in Nim
      real args[];
      real res;

      subber_ch = get_handle_real(nimSubber);

      args = '{4.5, 61.7, 1.44, 48.6, 0.213};
      res = call_real(subber_ch, nimSubber, args);
      $display("Real result of %p = %p", args, res);
    end : chandle_to_real_subber_proc

    $finish;
  end

endprogram : top
