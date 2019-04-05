// Time-stamp: <2019-04-04 23:39:14 kmodi>

program top;

  import "DPI-C" function real get_mean(input int values[]);
  import "DPI-C" function int get_max(input int values[]);
  import "DPI-C" function int get_min(input int values[]);

  initial begin
    int vals[];

    vals = '{1, 3, 5, 7, 9};

    $display("Mean of %p = %0.3f", vals, get_mean(vals));
    $display("Max of %p = %0d", vals, get_max(vals));
    $display("Min of %p = %0d", vals, get_min(vals));

    $finish;
  end

endprogram : top
