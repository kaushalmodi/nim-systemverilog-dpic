// Time-stamp: <2021-05-02 20:50:14 kmodi>

program top;

  typedef bit [7:0] BV_t;

  import "DPI-C" context function int f_bitvector_nim(input BV_t i
                                                      , output BV_t o
                                                      , inout BV_t io);
  export "DPI-C" function f_bitvector_sv;

  function int f_bitvector_sv(input BV_t i, output BV_t o, inout BV_t io);
    begin
      o = i + 1;
      io = o + 1;
      $display("f_bitvector_sv: i=%p, o=%p, io=%p", i, o, io);
      return io + 1;
    end
  endfunction : f_bitvector_sv

  initial begin
    BV_t i, o, io;

    i = 10;
    o = 100;
    io = 250;

    void'(f_bitvector_nim(i, o, io));
  end

endprogram : top
