// Time-stamp: <2019-04-05 13:04:00 kmodi>

program top;

  typedef struct {
    real mean;
    int max;
    int min;
  } params_s;

  import "DPI-C" function real get_mean(input int values[]);
  import "DPI-C" function int get_max(input int values[]);
  import "DPI-C" function int get_min(input int values[]);
  import "DPI-C" function void get_params(input int values[], output params_s p);

  initial begin
    params_s p;
    int vals[];

    vals = '{100, 3, 5, 9, 7};

    $display("Mean of %p = %0.3f", vals, get_mean(vals));
    $display("Max of %p = %0d", vals, get_max(vals));
    $display("Min of %p = %0d", vals, get_min(vals));

    get_params(vals, p);
    $display("Calculated params from %p = %p", vals, p);

    $finish;
  end

endprogram : top
