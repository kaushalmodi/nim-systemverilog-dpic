// Time-stamp: <2019-04-11 18:01:14 kmodi>

program top;

  parameter MAX = 20;

  typedef struct {
    real mean;
    int max;
    int min;
  } struct_elem_s;

  typedef struct {
    struct_elem_s x1, x2, x3;
  } out_struct_s;

  typedef struct {
    // int arr[];
    // Dynamic array in unpacked struct causes:
    //   xmvlog: *E,UNUSAG : unsupported element in unpacked struct datatype in formal argument.
    // So use a MAX length static array for now.
    int arr[MAX];
    int len;
  } in_struct_wrapper_s;

  typedef struct {
    in_struct_wrapper_s a, b, c;
  } in_struct_s;

  import "DPI-C" function void get_params(input in_struct_s in_str, output out_struct_s out_str);

  initial begin
    in_struct_s inp;
    out_struct_s outp;
    int vals[];

    vals = '{ 632, 68, 87, 73, 22, 63 };
    inp.a.len = vals.size;
    foreach (vals[i]) inp.a.arr[i] = vals[i];

    vals = '{ 104, 36, 53, 35, 00, 36, 51, 73 };
    inp.b.len = vals.size;
    foreach (vals[i]) inp.b.arr[i] = vals[i];

    vals = '{ 080, 83, 60, 66, 77, 50, 40, 64, 07, 24 };
    inp.c.len = vals.size;
    foreach (vals[i]) inp.c.arr[i] = vals[i];

    $display("Input struct = %p", inp);

    get_params(inp, outp);
    $display("Calculated params from that struct = %p", outp);

    $finish;
  end

endprogram : top
