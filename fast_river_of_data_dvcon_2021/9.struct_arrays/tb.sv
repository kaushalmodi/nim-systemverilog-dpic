// Time-stamp: <2021-05-03 13:57:11 kmodi>

program top;

  typedef struct packed {
    // bit [1:0] two_bits;
    // reg [1:0] two_regs;
    // bit [6:0] seven_bits;
    // reg [6:0] seven_regs;
    // bit [31:0] thirtytwo_bits;
    // reg [31:0] thirtytwo_regs;
    // bit [64:0] sixtyfive_bits;
    // reg [64:0] sixtyfive_regs;
    byte b;
    shortint si;
    int i;
    longint li;
  } my_struct_s;

  typedef struct {
    my_struct_s sa[10];
  } struct_wrap_t;

  // Mon May 03 12:40:05 EDT 2021 - kmodi
  // Xcelium does not support passing arrays of structs.
  // import "DPI-C" context function int f_array_of_struct_nim(input int size, inout array_of_struct_t io);
  //                                                                                                 |
  // xmvlog: *E,UNFRAG (tb.sv,22|101): unsupported datatype in formal argument.
  // xmhelp: 20.09-s009: (c) Copyright 1995-2021 Cadence Design Systems, Inc.
  // xrun/unfrag =
  //         In the current version of software only int, real, byte, short int, long int ,string  scalar values
  //         of type bit, logic and one dimension packed array of bit and logic, one dimensional open array of
  //         int are supported as function/task argument.
  //
  // .. but it does support passing structs containing arrays of structs.
  import "DPI-C" context function int f_array_of_struct_nim(inout struct_wrap_t io);

  initial begin
    struct_wrap_t io;
    int counter;

    foreach (io.sa[x]) begin
      // io.sa[x].two_regs = 1 + counter++;
      // io.sa[x].two_bits = 1 + counter++;
      io.sa[x].b = 10 + counter++;
      io.sa[x].si = 100 + counter++;
      io.sa[x].i = 1_000 + counter++;
      io.sa[x].li = 10_000 + counter++;
      $display("SV top (before Nim call), io.sa[%0d] = %p", x, io.sa[x]);
    end
    void'(f_array_of_struct_nim(io));
    foreach (io.sa[x]) begin
      $display("SV top (after Nim call), io.sa[%0d] = %p", x, io.sa[x]);
    end
  end

endprogram : top
