// Time-stamp: <2021-04-30 23:40:41 kmodi>

program top;

  typedef int array_of_int[10];

  import "DPI-C" context function int f_array_of_int_nim(input array_of_int i
                                                         , output array_of_int o
                                                         , inout array_of_int io);
  export "DPI-C" function f_array_of_int_sv;

  function bit f_array_of_int_sv(input array_of_int i
                                 , output array_of_int o
                                 , inout array_of_int io);
    begin
      foreach (o[x]) o[x] = i[x] + 1;
      foreach (io[x]) o[x] = o[x] + 1;
      $display("f_array_of_int_sv: i=%p", i);
      $display("f_array_of_int_sv: o=%p", o);
      $display("f_array_of_int_sv: io=%p", io);
      return 1;
    end
  endfunction : f_array_of_int_sv

  initial begin
    array_of_int i, o, io;

    foreach (i[x]) i[x] = 10;
    foreach (o[x]) o[x] = 100;
    foreach (io[x]) io[x] = 1000;

    void'(f_array_of_int_nim(i, o, io));
    void'(f_array_of_int_nim(i, o, io));
    void'(f_array_of_int_nim(i, o, io));
  end

endprogram : top
