// Time-stamp: <2019-01-29 15:45:32 kmodi>

program top;

  import "DPI-C" function string get_user_input();

  initial begin
    string t = get_user_input();
    $display("You typed \"%s\" in the Nim prompt.", t);
    $finish;
  end

endprogram : top
