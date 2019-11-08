// Time-stamp: <2019-11-08 14:30:19 kmodi>
// https://verificationacademy.com/forums/systemverilog/how-dpi-export-task-embedded-uvmdriver-c-code#answer-51530

class foo;
  int id;

  function new();
    id = 1;
  endfunction : new

  virtual function void print_id();
    $display("I am printing from the print_id function void in foo class");
    $display("My id is %0d", this.id);
  endfunction : print_id
endclass : foo

program top;

  export "DPI-C" function wrapper_function;
  import "DPI-C" context function void from_nim();

  // For UVM tests, you don't need to have this h handle global.
  // Use uvm_config_db::get/set.
  foo h;

  function void wrapper_function();
    h.print_id();
  endfunction : wrapper_function

  initial begin
    h = new;
    h.id = 100;

    from_nim();

    $finish;
  end

endprogram : top
