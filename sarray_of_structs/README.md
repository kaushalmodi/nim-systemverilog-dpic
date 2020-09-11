Xcelium does not support passing a static array of structs via DPI-C.

file: tb.sv
  import "DPI-C" printStruct = function void print_struct(input some_arr_s s_arr);
                                                                               |
xmvlog: *E,UNFRAG (tb.sv,16|79): unsupported datatype in formal argument.
        program worklib.top:sv
                errors: 1, warnings: 0
