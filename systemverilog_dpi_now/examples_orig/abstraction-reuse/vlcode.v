module bitadder(input a, input b, input ci, output s, output co);
        xor #1    x(s,   a,   b,  ci);
        and #1  iab(ab,  a,   b); and #1 iaci(aci, a,  ci);
        and #1 ibci(bci, b,  ci); or  #1    o(co, ab, aci, bci);
endmodule

module adder4_gate(output [3:0]s, input  [3:0]a, input  [3:0]b, input start, output done);
    reg reg_done;
    wire [3:0]ci;

    bitadder b0(a[0], b[0],  1'b0, s[0], ci[1]); bitadder b1(a[1], b[1], ci[1], s[1], ci[2]);
    bitadder b2(a[2], b[2], ci[2], s[2], ci[3]); bitadder b3(a[3], b[3], ci[3], s[3],    co);

    assign done = reg_done;
    always @(posedge start) begin
        #10; reg_done = 0; #10; reg_done = 1;
    end
endmodule

module top;
    reg start, clk;
    wire done;
    reg [3:0]a, b;
    wire [3:0]z, z_gate;

    adder4_gate adder4g(z_gate, a, b, start, done);

    export "DPI-C" task t_add;
    task t_add(output int unsigned z_, input int unsigned a_, input int unsigned b_);
        a = a_; b = b_;
        #1; start = 0; #1; start = 1;
        // HW calculation happens during this time...
        @(posedge done);
        z_ = z_gate;
    endtask

    import "DPI-C" context task c_test();
    initial begin
        c_test();
        $finish;
    end

    always begin
        clk = 0; #50; clk = 1; #50;
    end
endmodule
