// Time-stamp: <2019-01-21 14:19:26 kmodi>
// http://www.testbench.in/DP_09_PASSING_STRUCTS_AND_UNIONS.html

program main;

  export "DPI-C" function export_func;
  import "DPI-C" context function void import_func();

  // Packed struct
  typedef struct packed {
    int a;
    int b;
    byte c;
  } SV_struct;

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
    $finish;
  end

endprogram
