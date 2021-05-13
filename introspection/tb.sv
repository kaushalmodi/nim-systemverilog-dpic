// Time-stamp: <2021-05-13 02:33:02 kmodi>

module automatic top;

  import vpi_pkg::*; // https://github.com/kaushalmodi/nim-svvpi/blob/main/sv/vpi_pkg.sv

  string pathname = "top.";
  integer A = 2;
  vpiHandle my_handle;

  initial begin
    my_handle = vpi_handle_by_name({pathname, "A"}, null);
    $display("top.A is %0d", vpi_get_int_value(my_handle));
    vpi_put_int_value(my_handle, 3);
    $display("top.A is %0d", vpi_get_int_value(my_handle));
  end

  DUT DUT();
  vpiHandle listOfNetworks[string][$];

  initial begin
    doAllModules(null);
    foreach(listOfNetworks[simNet]) begin
      vpiHandle networks[$];
      networks = listOfNetworks[simNet];
      $display("Network %s", simNet);
      foreach(networks[nHandle]) begin
        $display(vpi_get_str(vpiFullName, networks[nHandle]));
      end
    end
  end // initial begin

  function void doAllModules(vpiHandle scope);
    vpiHandle moduleIterator, moduleHandle;
    moduleIterator = vpi_iterate(vpiModule, scope);
    if (moduleIterator == null) return;

    // while((moduleHandle = vpi_scan(moduleIterator)) != null) begin // Doesn't compile
    moduleHandle = vpi_scan(moduleIterator);
    while(moduleHandle != null) begin
      doAllModules(moduleHandle);
      print_timescale(moduleHandle);
      print_parameters(moduleHandle);
      collect_simulated_nets(moduleHandle);

      moduleHandle = vpi_scan(moduleIterator);
    end
  endfunction : doAllModules

  function void print_timescale(vpiHandle moduleHandle);
    int TimeUnit = vpi_get(vpiTimeUnit, moduleHandle);
    int TimePrec = vpi_get(vpiTimePrecision, moduleHandle);
    $display("Found Module %s Timescale: %0d/%0d",
             vpi_get_str(vpiFullName, moduleHandle),
             TimeUnit, TimePrec);
  endfunction : print_timescale

  function void print_parameters(vpiHandle moduleHandle);
    vpiHandle paramIterator, paramHandle;
    paramIterator = vpi_iterate(vpiParameter, moduleHandle);
    if (paramIterator == null) return;

    // while((paramHandle = vpi_scan(paramIterator)) != null) // Doesn't compile
    paramHandle = vpi_scan(paramIterator);
    while(paramHandle != null) begin
      $display("parameter %s = %0d",
               vpi_get_str(vpiFullName, paramHandle),
               vpi_get_int_value(paramHandle));

      paramHandle = vpi_scan(paramIterator);
    end
  endfunction : print_parameters

  function void collect_simulated_nets(vpiHandle moduleHandle);
    vpiHandle netIterator, netHandle;
    netIterator = vpi_iterate(vpiNet, moduleHandle);
    if (netIterator == null) return;

    // while((netHandle = vpi_scan(netIterator)) != null) doesn't compile
    netHandle = vpi_scan(netIterator);
    while(netHandle != null) begin
      listOfNetworks[
                     vpi_get_str(vpiFullName, vpi_handle(vpiSimNet, netHandle))
                     ].push_back(netHandle);

      netHandle = vpi_scan(netIterator);
    end
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
