module register4
(
    input clk,
    input enable,
    input[3:0] d,
    output reg[3:0] q
);
    always @(posedge clk)
    begin
        if(enable)
            q <= d;
    end

endmodule




always @(*)
