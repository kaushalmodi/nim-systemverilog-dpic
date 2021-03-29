// Time-stamp: <2021-03-29 16:17:50 kmodi>

program top;

  // * Neither sending nor receiving variables between SystemVerilog and C
  import "DPI-C" hello = function void hello_func();
  import "DPI-C" hello = task hello_task();

  // * Receiving SystemVerilog variables from C
  import "DPI-C" ret_cshort    = function shortint ret_shortint();
  import "DPI-C" ret_cint      = function int ret_int();
  import "DPI-C" ret_clonglong = function longint ret_longint();
  import "DPI-C" ret_cchar     = function byte ret_byte();

  import "DPI-C" ret_bit    = function bit ret_bit();
  import "DPI-C" ret_logic0 = function logic ret_logic0();
  import "DPI-C" ret_logic1 = function logic ret_logic1();
  import "DPI-C" ret_logicZ = function logic ret_logicZ();
  import "DPI-C" ret_logicX = function logic ret_logicX();
  import "DPI-C" ret_logic0 = function reg ret_reg0(); // logic returning procs can be used for reg return values too
  import "DPI-C" ret_logic1 = function reg ret_reg1();
  import "DPI-C" ret_logicZ = function reg ret_regZ();
  import "DPI-C" ret_logicX = function reg ret_regX();

  // DPI-C does not support functions returning shortreal
  import "DPI-C" ret_float64 = function real ret_real();

  import "DPI-C" ret_cstring = function string ret_string();

  import "DPI-C" ret_fooPtr = function chandle ret_chandle_nonnull();
  import "DPI-C" ret_nilPtr = function chandle ret_chandle_null();

  typedef struct {
    string name;
    string species;
    int age;
  } animal_s;
  // DPI-C does not support struct as return type.
  // import "DPI-C" ret_object = function animal_s ret_struct();

  // * Sending SystemVerilog variables to C
  import "DPI-C" print_object = function void print_struct(input animal_s in);
  import "DPI-C" print_tuple = function void print_struct2tuple(input animal_s in);

  initial begin
    hello_func();
    hello_task();
    $display("");

    $display("ret_shortint() returns %0d", ret_shortint());
    $display("ret_int() returns %0d", ret_int());
    $display("ret_longint() returns %0d", ret_longint());
    $display("ret_byte() returns %0d", ret_byte());
    $display("");

    $display("ret_bit() returns %0d", ret_bit());
    $display("ret_logic0() returns %0d", ret_logic0());
    $display("ret_logic1() returns %0d", ret_logic1());
    $display("ret_logicZ() returns %0d", ret_logicZ());
    $display("ret_logicX() returns %0d", ret_logicX());
    $display("ret_reg0() returns %0d", ret_reg0());
    $display("ret_reg1() returns %0d", ret_reg1());
    $display("ret_regZ() returns %0d", ret_regZ());
    $display("ret_regX() returns %0d", ret_regX());
    $display("");

    $display("ret_real() returns %0.10f", ret_real());
    $display("");

    $display("ret_string() returns %s", ret_string());
    $display("");

    begin
      chandle foo;
      foo = ret_chandle_nonnull();
      $display("ret_chandle_nonnull() is null? %p", foo == null);
      foo = ret_chandle_null();
      $display("ret_chandle_null() is null? %p", foo == null);
      $display("");
    end

    // DPI-C does not support struct as return type.
    // $display("ret_struct() returns %p", ret_struct());
    $display("");

    begin
      animal_s a;
      a.name = "Joe";
      a.species = "H. sapiens";
      a.age = 23;
      print_struct(a);
      print_struct2tuple(a);
    end

  end

endprogram

// https://github.com/grg/verilator/blob/master/include/vltstd/svdpi.h
// https://www.doulos.com/knowhow/sysverilog/tutorial/dpi/
// http://www.project-veripage.com/dpi_tutorial_1.php
