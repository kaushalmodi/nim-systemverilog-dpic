// Time-stamp: <2021-05-02 23:02:04 kmodi>

program top;

  typedef struct {
    bit b;
    logic l;
    int i;
    longint li;
  } my_struct_s;

  import "DPI-C" context function int f_my_struct_nim(input my_struct_s i
                                                      , output my_struct_s o
                                                      , inout my_struct_s io);
  export "DPI-C" function f_my_struct_sv;

  function bit f_my_struct_sv(input my_struct_s i, output my_struct_s o, inout my_struct_s io);
    begin
      o.b = i.b + 1;
      o.l = i.l + 1;
      o.i = i.i + 1;
      o.li = i.li + 1;

      io.b = o.b + 1;
      io.l = o.l + 1;
      io.i = o.i + 1;
      io.li = o.li + 1;
      $display("f_my_struct_sv: i=%p, o=%p, io=%p", i, o, io);
      return 1;
    end
  endfunction : f_my_struct_sv

  initial begin
    my_struct_s i, o, io;

    i = '{ b: 0,
           l: 1,
           i: 10,
           li: 10 };
    o = '{ b: 0,
           l: 1,
           i: 100,
           li: 100 };
    io = '{ b: 0,
            l: 1,
            i: 1000,
            li: 1000 };

    $display("SV top (before): i=%p, o=%p, io=%p", i, o, io);
    void'(f_my_struct_nim(i, o, io));
    $display("SV top (after): i=%p, o=%p, io=%p", i, o, io);
  end

endprogram : top
