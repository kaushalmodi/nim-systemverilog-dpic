// Time-stamp: <2019-01-21 16:07:16 kmodi>
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
    s_data.r = arr[2]; // This works because r of size byte is the last element
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
      //   SV: array element 0: p = 303379748, q = -1064739199, r = 9
      //   SV: array element 1: p = -1309649309, q = 112818957, r = -115
      //   SV: array element 2: p = -1295874971, q = -1992863214, r = 1
      //   SV: array element 3: p = 114806029, q = 992211318, r = 61
      //   SV: array element 4: p = 1993627629, q = 1177417612, r = -7
      //
      //     lower index = 0, upper index = 4
      //     Nim: Element at index 0 = (p: -1990295287, q: 355804352, r: 18)
      //     Nim: Element at index 1 = (p: -1183117939, q: -262774010, r: -79)
      //     Nim: Element at index 2 = (p: 928125441, q: -1031510647, r: -78)
      //     Nim: Element at index 3 = (p: 603027005, q: -674427589, r: 6)
      //     Nim: Element at index 4 = (p: 771198201, q: -732435130, r: 118)
      //
      //   ** Unpacked struct **
      //     lower index = 0, upper index = 4
      //     Nim: Element at index 0 = (p: 303379748, q: -1064739199, r: 9)
      //     Nim: Element at index 1 = (p: -1309649309, q: 112818957, r: -115)
      //     Nim: Element at index 2 = (p: -1295874971, q: -1992863214, r: 1)
      //     Nim: Element at index 3 = (p: 114806029, q: 992211318, r: 61)
      //     Nim: Element at index 4 = (p: 1993627629, q: 1177417612, r: -7)
      //
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
