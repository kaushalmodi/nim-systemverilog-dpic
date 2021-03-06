// Time-stamp: <2021-05-03 17:04:41 kmodi>

program top;

  parameter NUM_ELEMS = 3;

  typedef struct {
    bit [1:0] two_bits;
    logic [1:0] two_logics;
    bit [6:0] seven_bits;
    logic [6:0] seven_logics;
    bit [31:0] thirtytwo_bits;
    logic [31:0] thirtytwo_logics;
    bit [64:0] sixtyfive_bits;
    logic [64:0] sixtyfive_logics;
    byte b;
    shortint si;
    int i;
    longint li;
  } my_struct_s;

  typedef struct {
    my_struct_s sa[NUM_ELEMS];
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
      io.sa[x].two_bits = 2'h2;
      io.sa[x].two_logics = 2'bxz;
      io.sa[x].seven_bits = 7'h77;
      io.sa[x].thirtytwo_bits = 32'h3232_3232;
      io.sa[x].sixtyfive_bits = 65'h1_6565_6565_6565_6565;
      io.sa[x].b = 8'h33 + counter++;
      io.sa[x].si = 16'haa_55 + counter++;
      io.sa[x].i = 32'h1234_5678 + counter++;
      io.sa[x].li = 64'ha5a5_b6b6_c7c7_d8d8 + counter++;
      $display("SV top (before Nim call), io.sa[%0d].two_bits         = %20d | 'h%x", x, io.sa[x].two_bits, io.sa[x].two_bits);
      $display("SV top (before Nim call), io.sa[%0d].two_logics       = %20d | 'h%x", x, io.sa[x].two_logics, io.sa[x].two_logics);
      $display("SV top (before Nim call), io.sa[%0d].seven_bits       = %20d | 'h%x", x, io.sa[x].seven_bits, io.sa[x].seven_bits);
      $display("SV top (before Nim call), io.sa[%0d].seven_logics     = %20d | 'h%x", x, io.sa[x].seven_logics, io.sa[x].seven_logics);
      $display("SV top (before Nim call), io.sa[%0d].thirtytwo_bits   = %20d | 'h%x", x, io.sa[x].thirtytwo_bits, io.sa[x].thirtytwo_bits);
      $display("SV top (before Nim call), io.sa[%0d].thirtytwo_logics = %20d | 'h%x", x, io.sa[x].thirtytwo_logics, io.sa[x].thirtytwo_logics);
      $display("SV top (before Nim call), io.sa[%0d].sixtyfive_bits   = %20d | 'h%x", x, io.sa[x].sixtyfive_bits, io.sa[x].sixtyfive_bits);
      $display("SV top (before Nim call), io.sa[%0d].sixtyfive_logics = %20d | 'h%x", x, io.sa[x].sixtyfive_logics, io.sa[x].sixtyfive_logics);
      $display("SV top (before Nim call), io.sa[%0d].b                = %20d | 'h%x", x, io.sa[x].b, io.sa[x].b);
      $display("SV top (before Nim call), io.sa[%0d].si               = %20d | 'h%x", x, io.sa[x].si, io.sa[x].si);
      $display("SV top (before Nim call), io.sa[%0d].i                = %20d | 'h%x", x, io.sa[x].i, io.sa[x].i);
      $display("SV top (before Nim call), io.sa[%0d].li               = %20d | 'h%x", x, io.sa[x].li, io.sa[x].li);
    end
    void'(f_array_of_struct_nim(io));
    foreach (io.sa[x]) begin
      $display("SV top (after Nim call), io.sa[%0d].b  = %20d | 'h%x", x, io.sa[x].b, io.sa[x].b);
      $display("SV top (after Nim call), io.sa[%0d].si = %20d | 'h%x", x, io.sa[x].si, io.sa[x].si);
      $display("SV top (after Nim call), io.sa[%0d].i  = %20d | 'h%x", x, io.sa[x].i, io.sa[x].i);
      $display("SV top (after Nim call), io.sa[%0d].li = %20d | 'h%x", x, io.sa[x].li, io.sa[x].li);
    end
  end

endprogram : top
