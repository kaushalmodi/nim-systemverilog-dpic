
module top;
    reg clk;
    shortint result;

    import "DPI-C" context task c_store(input int addr, input shortint data);

    // return output from C
    import "DPI-C" context task c_retrieve(input int addr, output shortint data);

    // Can't be a function -> consumes time.
    export "DPI-C" task vl_posedge_clk;
    task vl_posedge_clk();
        @(posedge clk);
    endtask

    initial begin
        c_store(100, 1024);
        result = 0;
        c_retrieve(100, result);
        $display("Mem[100]=%d", result);
        $finish;
    end

    always begin
        clk = 0; #50; clk = 1; #50;
    end
endmodule

