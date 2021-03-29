// Time-stamp: <2021-03-29 17:27:40 kmodi>

program top;

  parameter NUM = 3;

  typedef struct {
    int scalar_int;
    string scalar_string;
  } my_struct_s;

  import "DPI-C" function void print_object(input my_struct_s s[]);

  initial begin
    my_struct_s s[];

    s = new[NUM];

    for (int i = 0; i < NUM; i++) begin
      s[i].scalar_int = 100 + i;
      s[i].scalar_string = $sformatf("%0d", s[i].scalar_int);
      $display("Value of the struct printed from SV: s[%0d] = %p", i, s[i]);
    end

    print_object(s);

    $finish;
  end

endprogram : top
