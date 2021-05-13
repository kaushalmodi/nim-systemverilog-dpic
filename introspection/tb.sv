// Time-stamp: <2021-05-13 13:59:48 kmodi>

module automatic top;

  import vpi_pkg::*; // https://github.com/kaushalmodi/nim-svvpi/blob/main/sv/vpi_pkg.sv

  integer A = 2;

  initial begin
    VpiHandle my_handle;

    my_handle = vpi_handle_by_name("top.A");
    $display("top.A is %0d", vpi_get_value_int(my_handle));
    vpi_put_value_int(my_handle, 3);
    $display("top.A is %0d", vpi_get_value_int(my_handle));
  end

  DUT u_dut();

  VpiHandle listOfNetworks[string][$];

  initial begin
    doAllModules(.level(0));

    $display("\nNetworks:");
    foreach (listOfNetworks[simNet]) begin
      VpiHandle networks[$];
      networks = listOfNetworks[simNet];
      if (networks.size() == 1) begin
        $display("\n %s is unconnected!", simNet);
        continue;
      end else begin
        $display("\n %s is connected to %0d other nets:", simNet, networks.size()-1);
      end

      foreach (networks[nHandle]) begin
        string conn;
        conn = vpi_get_str(vpiFullName, networks[nHandle]);
        if (conn == simNet) continue;
        $display("  - %s", conn);
      end
    end
  end // initial begin

  function void doAllModules(input int level, VpiHandle scope = null);
    VpiHandle moduleIterator;

    moduleIterator = vpi_iterate(vpiModule, scope);
    if (moduleIterator == null) return;

    do begin
      VpiHandle moduleHandle;
      moduleHandle = vpi_scan(moduleIterator);
      if (moduleHandle == null) return;

      $display("\n%sIn Module %s", {level{" "}}, vpi_get_str(vpiFullName, moduleHandle));
      print_timescale(level, moduleHandle);
      print_parameters(level, moduleHandle);
      collect_simulated_nets(moduleHandle);
      doAllModules(level+1, moduleHandle);
    end while (1);
  endfunction : doAllModules

  function void print_timescale(input int level, VpiHandle moduleHandle);
    int time_unit = vpi_get(vpiTimeUnit, moduleHandle);
    int time_prec = vpi_get(vpiTimePrecision, moduleHandle);
    $display("%s timescale: %0d/%0d", {level{" "}}, time_unit, time_prec);
  endfunction : print_timescale

  function void print_parameters(input int level, VpiHandle moduleHandle);
    VpiHandle paramIterator;
    paramIterator = vpi_iterate(vpiParameter, moduleHandle);
    if (paramIterator == null) return;

    do begin
      VpiHandle paramHandle;
      paramHandle = vpi_scan(paramIterator);
      if (paramHandle == null) return;

      $display("%s parameter %s = %0d",
               {level{" "}}, vpi_get_str(vpiFullName, paramHandle), vpi_get_value_int(paramHandle));
    end while (1);
  endfunction : print_parameters

  function void collect_simulated_nets(input VpiHandle moduleHandle);
    VpiHandle netIterator;
    netIterator = vpi_iterate(vpiNet, moduleHandle);
    if (netIterator == null) return;

    do begin
      VpiHandle netHandle;
      netHandle = vpi_scan(netIterator);
      if (netHandle == null) return;

      listOfNetworks[
                     vpi_get_str(vpiFullName, vpi_handle(vpiSimNet, netHandle))
                     ].push_back(netHandle);
    end while (1);
  endfunction : collect_simulated_nets

endmodule : top

module DUT;
  timeunit 1ms;
  timeprecision 10ns;

  wire w1, w2, w3;

  sub #(1) u1(w1, w2);
  sub #(2) u2(w1, w2);
  dub u3(w1);
endmodule : DUT

module dub(inout wire p3);
  wire w6;

  sub #(3) u5(w6, p3);
endmodule : dub

module sub(inout wire p1, p2);
  parameter P = 0;

  wire p3;
endmodule : sub
