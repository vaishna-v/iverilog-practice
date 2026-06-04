module register4_tb;

    reg[3:0] d;
    wire[3:0] q;
    reg enable;
 
    reg clk;
    register4 uut(.clk(clk), .enable(enable), .d(d), .q(q));

    // make a clock-
    initial begin
        clk = 0;

        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        enable = 1;

        $dumpfile("waves.vcd");
        $dumpvars(0, register4_tb);


        d = 4'b0000;        // d = <size>'<base><value>

        #2 d = 4'b1010;
        #2 d = 4'b1101;
        #2 d = 4'b0101;

        #2
        $finish;
    end

    initial begin
        $monitor("time = %0t d = %b q = %b", $time, d, q);
    end

endmodule