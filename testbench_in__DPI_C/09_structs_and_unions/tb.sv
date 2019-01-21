// Time-stamp: <2019-01-21 16:02:39 kmodi>
// http://www.testbench.in/DP_09_PASSING_STRUCTS_AND_UNIONS.html

program main;

  // Array of packed structs
  typedef struct packed {
    int p;
    int q;
    byte r;
  } PkdStruct;
  PkdStruct arr_data [0:4];

  typedef struct {
    int p;
    int q;
    byte r;
  } UnPkdStruct;
  UnPkdStruct arr_data2 [0:4];

  export "DPI-C" function export_func;
  import "DPI-C" context function void import_func();
  import "DPI-C" function void send_arr_struct_pkd (input PkdStruct arr []);

  // I cannot map the same Nim function "send_arr_struct_pkd" to
  // "send_arr_struct_pkd" and "send_arr_struct_unpkd" which accept
  // different data types. So below won't work .. I get:
  //   xmsim: *E,SIGUSR: Unix Signal SIGSEGV raised from user application code.
  // import "DPI-C" send_arr_struct_pkd = function void send_arr_struct_unpkd (input UnPkdStruct arr []);
  //
  // But instead, within Nim, I can have send_arr_struct_unpkd call
  // the send_arr_struct_pkd proc, do the below mapping, and it will
  // work!
  import "DPI-C" function void send_arr_struct_unpkd (input UnPkdStruct arr []);

  function void export_func (input int arr[3]);
    PkdStruct s_data;

    $display("  SV: arr = %p", arr);
    s_data.p = arr[0];
    s_data.q = arr[1];
    s_data.r = arr[2];
    $display("  SV: s_data = %p", s_data);
  endfunction

  initial begin
    import_func();
    $display("");

    foreach (arr_data[i]) begin
      automatic int p_elem, q_elem;
      automatic byte r_elem;
      p_elem = $random;
      q_elem = $random;
      r_elem = $random;

      // Mon Jan 21 15:24:16 EST 2019 - kmodi
      // FIXME: Cadence Xcelium
      // The order of elements is reversed in the packaged struct sent via
      // DPI-C.
      // arr_data[i] = { p_elem, q_elem, r_elem }; // This is the correct way, but DPI-C flips the order
      arr_data[i] = { r_elem, q_elem, p_elem }; // Workaround: Pack the data in the array in incorrect order so that DPI-C corrects it by flipping the order again.

      arr_data2[i].p = p_elem;
      arr_data2[i].q = q_elem;
      arr_data2[i].r = r_elem;

      $display("SV: array element %0d: p = %0d, q = %0d, r = %0d",
               i, p_elem, q_elem, r_elem);
    end // foreach (arr_data[i])
    $display("");

    send_arr_struct_pkd(arr_data);

    // But then I run the same function (it's the same function call
    // if you look in the Nim code) but this time passing an
    // *unpacked* struct, and this time the order of the struct
    // elements is correct!
    send_arr_struct_unpkd(arr_data2);

    $finish;
  end

endprogram
