// Time-stamp: <2019-03-25 17:03:53 kmodi>

program top;

  import "DPI-C" function void dump_cfg();
  import "DPI-C" function int get_cfg_int(input string group, input string key);
  import "DPI-C" function real get_cfg_float(input string group, input string key);
  import "DPI-C" function string get_cfg_string(input string group, input string key);
  import "DPI-C" function int get_cfg_int_array_num_elems(input string group, input string key);
  import "DPI-C" function void get_cfg_int_array(input string group, input string key,
                                                 output int arr_val[]);

  initial begin
    static string groups[] = '{"group1", "group2"};

    dump_cfg();

    foreach (groups[i]) begin
      string key;
      int arr_int[];

      key = "key_int";
      $display("%0s[%0s] = %0d", groups[i], key, get_cfg_int(groups[i], key));

      key = "key_float";
      $display("%0s[%0s] = %0.3f", groups[i], key, get_cfg_float(groups[i], key));

      key = "key_string";
      $display("%0s[%0s] = %0s", groups[i], key, get_cfg_string(groups[i], key));

      key = "key_int_array";
      arr_int = new[get_cfg_int_array_num_elems(groups[i], key)]; // Allocate memory for the dynamic array
      get_cfg_int_array(groups[i], key, arr_int);
      $display("%0s[%0s] = %p", groups[i], key, arr_int);
    end

    $finish;
  end

endprogram : top
