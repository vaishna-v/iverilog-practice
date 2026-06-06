module mod3 (
    input  [7:0] x,
    output [1:0] rem
);

    function [1:0] next_state;
        input [1:0] state;
        input bit_in;

        begin
            case (state)
                2'd0: next_state = bit_in ? 2'd1 : 2'd0;
                2'd1: next_state = bit_in ? 2'd0 : 2'd2;
                2'd2: next_state = bit_in ? 2'd2 : 2'd1;
                default: next_state = 2'd0;
            endcase
        end
    endfunction

    wire [1:0] s1, s2, s3, s4, s5, s6, s7, s8;

    assign s1 = next_state(2'd0, x[7]);
    assign s2 = next_state(s1,   x[6]);
    assign s3 = next_state(s2,   x[5]);
    assign s4 = next_state(s3,   x[4]);
    assign s5 = next_state(s4,   x[3]);
    assign s6 = next_state(s5,   x[2]);
    assign s7 = next_state(s6,   x[1]);
    assign s8 = next_state(s7,   x[0]);

    assign rem = s8;

endmodule



