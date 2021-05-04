// Time-stamp: <2021-05-04 01:42:49 kmodi>

program top;

  import "DPI-C" context function chandle f_chandle_nim(input chandle i,
                                                        output chandle o,
                                                        inout chandle io);
  export "DPI-C" function f_chandle_sv;

  function chandle f_chandle_sv(input chandle i, output chandle o, inout chandle io);
    o = i;
    io = o;
    return i;
  endfunction : f_chandle_sv

  initial begin
    chandle i, o, io, o2, io2, ret2, o3, io3;
    void'(f_chandle_nim(i, o, io));
    $display("SV top: i = %x, o = %x, io = %x\n", i, o, io);

    ret2 = f_chandle_nim(o, o2, io2);
    $display("SV top: o = %x, o2 = %x, io2 = %x\n", o, o2, io2);

    void'(f_chandle_nim(ret2, o3, io3));
    $display("SV top: ret2 = %x, o3 = %x, io3 = %x\n", ret2, o3, io3);
  end

endprogram : top
