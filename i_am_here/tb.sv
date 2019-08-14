// Time-stamp: <2019-08-13 23:34:56 kmodi>

program top;

  // init_val:
  //   If negative, the here counter increments from the previous value.
  //   Else, the here counter gets set to the passed value.
  //     The here counter auto-initializes to 0 if not set using init_val.
  // enable_sticky:
  //   If negative, the state of "here debug enable" stays the same as before.
  //   Else if enable_sticky is 0, the here debug state gets disabled.
  //   Else if enable_sticky is positive, the here debug state gets enabled.
  //     The enable state auto-initializes to 1 if not set using enable_sticky.
  import "DPI-C" hereDebug = function void here_debug(input int init_val = -1, int enable_sticky = -1, real real_val = $realtime);
  import "DPI-C" context hereDebugCntxt = function void here_debug_cntxt(input int init_val = -1, int enable_sticky = -1, real real_val = $realtime);

  initial begin
    fork
      here_debug(, , 0.11);      // 0.0 ns (1) enable=1, counter=0                  -> [0.11] I am here 0   ==actual-order-of-printing==> [0.11] I am here 0
      here_debug(, 0, 0.22);     // 0.0 ns    (2) enable=0, counter=0                                                                     [0.55] I am here 1
      here_debug(, , 0.33);      // 0.0 ns       (3) enable=0, counter=0                                                                  [0.44] I am here 2
      begin
        #2;
        here_debug(, , 0.44);    // 2.0 ns               (6) enable=1, counter=2    -> [0.44] I am here 2
      end
      begin
        #1;
        here_debug(, 1, 0.55);   // 1.0 ns            (5) enable=1, counter=1       -> [0.55] I am here 1
      end
      here_debug(, , 0.66);      // 0.0 ns         (4) enable=0, counter=0
    join

    here_debug();
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

    here_debug_cntxt();
    here_debug_cntxt();
    here_debug_cntxt(200);
    here_debug_cntxt(200, 0); // These will not be printed
    here_debug_cntxt(); // These will not be printed
    here_debug_cntxt(0); // These will not be printed
    here_debug_cntxt(); // These will not be printed
    here_debug_cntxt(); // These will not be printed
    here_debug_cntxt(); // These will not be printed
    here_debug_cntxt(99, 1);
    here_debug_cntxt();
    here_debug_cntxt();
    here_debug_cntxt();
    here_debug_cntxt();

    $finish;
  end

endprogram : top
