// Time-stamp: <2021-05-02 22:31:36 kmodi>

program top;

  typedef logic [7:0] LV_t;

  import "DPI-C" context function int f_logicvector_nim(input LV_t i
                                                        , output LV_t o
                                                        , inout LV_t io);
  export "DPI-C" function f_logicvector_sv;

  function int f_logicvector_sv(input LV_t i, output LV_t o, inout LV_t io);
    begin
      o = i;
      for (int n = 0; n < 8; n++)
        io[n] = o[8-1-n];
      $display("f_logicvector_sv: i=%b, o=%b, io=%b", i, o, io);
      return 1;
    end
  endfunction : f_logicvector_sv

  initial begin
    LV_t i, o, io;

    i = 8'b01xz01xz;
    io = 8'b01xz01xz;

    $display("SV top (before): i=%b, o=%b, io=%b", i, o, io);
    void'(f_logicvector_nim(i, o, io));
    $display("SV top (after): i=%b, o=%b, io=%b", i, o, io);
  end

endprogram : top
