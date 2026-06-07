module ram1024
(
    input clk,
    input we,

    input  [6:0] addr,  // for 128 locations
    input  [7:0] din,

    output [7:0] dout
);

    reg [7:0] mem [0:127];

    always @(posedge clk)
    begin
        if(we)
            mem[addr] <= din;
    end

    assign dout = mem[addr];

endmodule



module rom128
(
    input  [3:0] addr,
    output [7:0] data
);

    reg [7:0] mem [0:15];

    initial
    begin
        mem[0]  = 8'h00;
        mem[1]  = 8'h01;
        mem[2]  = 8'h02;
        mem[3]  = 8'h03;
        mem[4]  = 8'h04;
        mem[5]  = 8'h05;
        mem[6]  = 8'h06;
        mem[7]  = 8'h07;
        mem[8]  = 8'h08;
        mem[9]  = 8'h09;
        mem[10] = 8'h0A;
        mem[11] = 8'h0B;
        mem[12] = 8'h0C;
        mem[13] = 8'h0D;
        mem[14] = 8'h0E;
        mem[15] = 8'h0F;
    end

    assign data = mem[addr];

endmodule