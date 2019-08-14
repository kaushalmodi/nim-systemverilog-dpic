// Time-stamp: <2019-08-14 09:28:00 kmodi>

`timescale 1ns/1ns

`include "uvm_macros.svh"
import uvm_pkg::*;

package here_pkg;
  // init_val:
  //   If negative, the here counter increments from the previous value.
  //   Else, the here counter gets set to the passed value.
  //     The here counter auto-initializes to 0 if not set using init_val.
  // enable_sticky:
  //   If negative, the state of "here debug enable" stays the same as before.
  //   Else if enable_sticky is 0, the here debug state gets disabled.
  //   Else if enable_sticky is positive, the here debug state gets enabled.
  //     The enable state auto-initializes to 1 if not set using enable_sticky.
  // real_val:
  //   If negative, this value is not embedded in the string returned by hereDebug.
  //   Else, this value is prefixed to the returned string by hereDebug.
  //     Ideally, if this value is set, it should be set to $realtime.
  import "DPI-C" context hereDebug = function string here_debug_str(input int init_val = -1,
                                                                    input int enable_sticky = -1,
                                                                    input real real_val = -1.0);

  function void here_debug(input int init_val = -1, int enable_sticky = -1, real real_val = -1.0, string scope = $sformatf("%m"));
    string str;
    begin
      str = here_debug_str(init_val, enable_sticky, real_val);
      if (str != "") `uvm_info("HERE", $sformatf("%s [%s]", str, scope), UVM_MEDIUM)
    end
  endfunction : here_debug

endpackage : here_pkg

module top;

  import here_pkg::*;

  initial begin
    // Print the simulation time in ns by default
    $timeformat(-9, 0, "ns", 11);  // units, precision, suffix, min field width
    run_test("my_test");
  end

  initial begin
    fork
      here_debug(, , 0.11);      // 0.0 ns (1) enable=1, counter=0                -> @0.11 <0> I am in `top' :HERE:        ==actual-order-of-printing==> @0.11 <0> I am in `top' :HERE:
      here_debug(, 0, 0.22);     // 0.0 ns    (2) enable=0, counter=0                                                                                    @0.55 <1> I am in `top' :HERE:
      here_debug(, , 0.33);      // 0.0 ns       (3) enable=0, counter=0                                                                                 @0.44 <2> I am in `top' :HERE:
      begin
        #2;
        here_debug(, , 0.44);    // 2.0 ns               (6) enable=1, counter=2        -> @0.44 <2> I am in `top' :HERE:
      end
      begin
        #1;
        here_debug(, 1, 0.55);   // 1.0 ns            (5) enable=1, counter=1        -> @0.55 <1> I am in `top' :HERE:
      end
      here_debug(, , 0.66);      // 0.0 ns         (4) enable=0, counter=0
    join

    here_debug(,,,$sformatf("%m"));
    here_debug();
    here_debug(100);
    here_debug();
    here_debug();
    here_debug(0);
    here_debug();
    here_debug();
    here_debug();
    here_debug(10);
    here_debug();
    here_debug();
    here_debug();
    here_debug();
    here_debug(200);
    here_debug(200, 0); // These will not be printed
    here_debug(); // These will not be printed
    here_debug(0); // These will not be printed
    here_debug(); // These will not be printed
    here_debug(); // These will not be printed
    here_debug(); // These will not be printed
    here_debug(99, 1);
    here_debug();
    here_debug();
    here_debug();
    here_debug();
    here_debug();
  end // initial begin

endmodule : top

// This is a virtual class; this class cannot be created and thus also should
// not have the factory registration (`uvm_component_utils)
virtual class my_base_test extends uvm_test;

  import here_pkg::*;

  function new(string name = "my_base_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("HERE2", $sformatf("%s", here_debug_str()), UVM_MEDIUM)
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    begin
      super.build_phase(phase);
      here_debug(,,,$sformatf("%m"));
    end
  endfunction : build_phase
endclass : my_base_test

class my_test extends my_base_test;
  `uvm_component_utils(my_test)

  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
    here_debug(,,,$sformatf("%m"));
  endfunction : new

  virtual task run_phase(uvm_phase phase);
    begin
      super.run_phase(phase);
      phase.raise_objection(this, $sformatf("%s: At the beginning of run phase", get_type_name()));

      #5;

      here_debug(,,,$sformatf("%m"));

      `uvm_info("HELLO", "Hello", UVM_MEDIUM)
      #10;

      phase.drop_objection(this);
    end
  endtask : run_phase
endclass : my_test
