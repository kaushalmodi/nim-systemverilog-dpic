// Time-stamp: <2021-06-12 12:13:09 kmodi>

program top;

  import "DPI-C" function void get_string_arr(output string s_arr[]);

  initial begin
    string s_arr1[], s_arr3[], s_arr4[];

    s_arr1 = new[1]; // dyn array shorter than Nim seq length
    s_arr3 = new[3]; // dyn array equal to Nim seq length
    s_arr4 = new[4]; // dyn array longer than Nim seq length

    get_string_arr(s_arr1);
    get_string_arr(s_arr3);
    get_string_arr(s_arr4);

    $display("s_arr1: %p", s_arr1);
    $display("s_arr3: %p", s_arr3);
    $display("s_arr4: %p", s_arr4);

    $finish;
  end

endprogram : top
