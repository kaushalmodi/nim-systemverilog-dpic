// Time-stamp: <2019-01-29 17:11:57 kmodi>

program top;

  import "DPI-C" function void nim_eval_string(string code);

  initial begin
    nim_eval_string("echo \"Hello from SV!\"");
    $finish;
  end

endprogram : top
