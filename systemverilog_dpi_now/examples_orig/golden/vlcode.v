
module top;
    reg clk;

    import "DPI-C" context task c_test();
    export "DPI-C" task vl_task;
    task vl_task(
      input int inp1, 
      input int inp2, 
      output int result);
        int n;
        result = 0;
        @(posedge clk);
        for(n = 0; n < 32; n++) begin
            if (inp2 & 1'b1) begin
                result += inp1;
            end
            inp1 <<= 1;
            inp2 >>= 1;
            @(posedge clk);
        end
    endtask

    initial begin
        c_test();
        $finish;
    end

    always begin
        clk = 0; #50; clk = 1; #50;
    end
endmodule

