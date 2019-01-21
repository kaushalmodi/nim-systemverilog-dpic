// Time-stamp: <2019-01-21 15:23:19 kmodi>
// http://www.testbench.in/DP_09_PASSING_STRUCTS_AND_UNIONS.html

program main;

  // Using arrays to populate packed struct
  typedef struct packed {
    int a;
    int b;
    byte c;
  } SV_struct;

  // Array of packed structs
  typedef struct packed {
    int p;
    int q;
    // byte r;
    int r;
  } PkdStruct;
  PkdStruct arr_data [0:4];

  export "DPI-C" function export_func;
  import "DPI-C" context function void import_func();
  import "DPI-C" function void send_arr_packed_struct (input PkdStruct arr []);

  function void export_func (input int arr[3]);
    SV_struct s_data;

    $display("  SV: arr = %p", arr);
    s_data.a = arr[0];
    s_data.b = arr[1];
    s_data.c = arr[2];
    $display("  SV: s_data = %p", s_data);
  endfunction

  initial begin
    import_func();

    $display("");
    foreach (arr_data[i]) begin
      arr_data[i] = { $random, $random, $random };
      $display("SV: arr_data[%0d] = '{p = %0d, q = %0d, r = %0d}",
               i, arr_data[i].p, arr_data[i].q, arr_data[i].r);
    end
    send_arr_packed_struct(arr_data);

    $finish;
  end

endprogram
