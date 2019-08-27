// Time-stamp: <2019-08-14 09:38:06 kmodi>

`timescale 1ns/1ns

`include "uvm_macros.svh"
import uvm_pkg::*;

package here_pkg;
  // init_val:
  //   If negative, the here counter increments from the previous value.
  //   Else, the here counter gets set to the passed value.
  //     The here counter auto-initializes to 0 if not set using init_val.
  // real_val:
  //   If negative, this value is not embedded in the string returned by hereDebug.
  //   Else, this value is prefixed to the returned string by hereDebug.
  //     Ideally, if this value is set, it should be set to $realtime.
  import "DPI-C" context hereDebug = function string here_debug_str(input int init_val = -1,
                                                                    input real real_val = -1.0);

  function void here_debug(input int init_val = -1, real real_val = -1.0, string scope = $sformatf("%m"));
    string str;
    begin
      str = here_debug_str(init_val, real_val);
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
      here_debug(, 0.11);
      here_debug(, 0.22);
      here_debug(, 0.33);
      begin
        #2;
        here_debug(, 0.44);
      end
      begin
        #1;
        here_debug(, 0.55);
      end
      here_debug(, 0.66);
    join

    here_debug(,,$sformatf("%m"));
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
    here_debug(99);
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
      here_debug(,,$sformatf("%m"));
    end
  endfunction : build_phase
endclass : my_base_test

class my_test extends my_base_test;
  `uvm_component_utils(my_test)

  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
    here_debug(,,$sformatf("%m"));
  endfunction : new

  virtual task run_phase(uvm_phase phase);
    begin
      super.run_phase(phase);
      phase.raise_objection(this, $sformatf("%s: At the beginning of run phase", get_type_name()));

      #5;

      here_debug(,,$sformatf("%m"));

      $stacktrace;

      `uvm_info("HELLO", "Hello", UVM_MEDIUM)
      #10;

      phase.drop_objection(this);
    end
  endtask : run_phase
endclass : my_test
