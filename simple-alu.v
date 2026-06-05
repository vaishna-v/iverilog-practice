module fulladder
(
    input a,
    input b,
    input c,            // c is the carry which came from previous bit addition,
    output sum,
    output carry
);

    assign carry = a&b | b&c | c&a;
    assign sum = a ^ b ^ c;
endmodule


module bit8adder
(
    input[7:0] a,
    input[7:0] b,
    input carry_in,

    output[7:0] result,
    output carry,
    output auxiliary_carry,
    output zero
);

    wire[7:0] carries;
    // Addition a0 b0
    fulladder fa0(.a(a[0]), .b(b[0]), .c(carry_in), .sum(result[0]), .carry(carries[0]));
    fulladder fa1(.a(a[1]), .b(b[1]), .c(carries[0]), .sum(result[1]), .carry(carries[1]));
    fulladder fa2(.a(a[2]), .b(b[2]), .c(carries[1]), .sum(result[2]), .carry(carries[2]));
    fulladder fa3(.a(a[3]), .b(b[3]), .c(carries[2]), .sum(result[3]), .carry(carries[3]));
    fulladder fa4(.a(a[4]), .b(b[4]), .c(carries[3]), .sum(result[4]), .carry(carries[4]));
    fulladder fa5(.a(a[5]), .b(b[5]), .c(carries[4]), .sum(result[5]), .carry(carries[5]));
    fulladder fa6(.a(a[6]), .b(b[6]), .c(carries[5]), .sum(result[6]), .carry(carries[6]));
    fulladder fa7(.a(a[7]), .b(b[7]), .c(carries[6]), .sum(result[7]), .carry(carries[7]));
    
    assign auxiliary_carry = carries[3];
    assign carry = carries[7];
    assign zero = (result == 8'b0);

endmodule




module bit8subtractor
(
    input[7:0] a,
    input[7:0] b,

    output[7:0] result,

    // Expose flags-
    output zero,
    output carry,
    output auxiliary_carry
);

    // invert 2
    wire[7:0] b_inv;
    assign b_inv = ~b;

    // add a and b
    wire temp_carry;
    wire auxiliary_carry_temp;
    bit8adder ba1(.a(a), .b(b_inv), .carry_in(1'b1), .result(result), .carry(temp_carry), .auxiliary_carry(auxiliary_carry_temp), .zero(zero));

    // invert flags-
    assign carry = ~temp_carry;
    assign auxiliary_carry = ~auxiliary_carry_temp;


endmodule


module bit8inverter
(
    input[7:0] a,
    output[7:0] result,

    output zero
);
    assign result = ~a;
    assign zero = (result == 8'b0);

    
endmodule


module bit8comparatorUnsigned      
(
    input[7:0] a,
    input[7:0] b,

    output aGreaterThanB,
    output bGreaterThanA,
    output aEqualsB
);
    wire zero;
    wire carry;
    wire auxiliary_carry;
    
    wire[7:0] result;

    bit8subtractor bs(.a(a), .b(b), .result(result), .zero(zero), .carry(carry), .auxiliary_carry(auxiliary_carry));

    assign aGreaterThanB = (zero == 0 & carry == 0);      // sign flag should be zero
    assign bGreaterThanA = (zero==0 & carry == 1);                        // sign flag should be 1
    assign aEqualsB = (zero==1 && carry==0);

endmodule



module flagregisters
(
    input clk,
    
    input[5:0] new_flags,   
    output wire[5:0] current_status
);
    // Registers: zero, aux_carry, carry, greater_than, less_than, equal_to;
    reg[5:0] flags;
    assign current_status = flags;

    always @(posedge clk)
    begin
        flags <= new_flags;
    end 
endmodule


module ALU
(
    input clk,
    input[7:0] a,
    input[7:0] b,
    output reg[7:0] result,
    input[1:0] op
);
    // op = 0: Addition, 1: Subtraction, 2: Invertion, 3: Compare

    wire[7:0] addition_result;
    wire[7:0] subtraction_result;
    wire[7:0] inversion_result;

    wire addition_zero, addition_carry, addition_auxiliary;
    wire subtraction_zero, subtraction_carry, subtraction_auxiliary;
    wire inversion_zero;
    wire comp_greater, comp_less, comp_equal;

    bit8adder ba(.a(a), .b(b), .carry_in(1'b0), .result(addition_result), .carry(addition_carry), .auxiliary_carry(addition_auxiliary), .zero(addition_zero));
    bit8subtractor bs(.a(a), .b(b), .result(subtraction_result), .zero(subtraction_zero), .carry(subtraction_carry), .auxiliary_carry(subtraction_auxiliary));
    bit8inverter bi(.a(a), .result(inversion_result), .zero(inversion_zero));
    bit8comparatorUnsigned bc(.a(a), .b(b), .aGreaterThanB(comp_greater), .bGreaterThanA(comp_less), .aEqualsB(comp_equal));


    reg[5:0] new_status;
    

    wire[5:0] current_status;
    // access registers-
    flagregisters flags(.clk(clk), .new_flags(new_status), .current_status(current_status));
    // to make any change in flag, make changes to new_status

    always @(*)
    begin
        new_status = current_status;
        result = 8'h0;  
        // for addition change zero, carry and auxcarry flag, 
        // for subtration change the same
        // for inversion change zero
        // for comparator, change less than equal to and greater 
        case(op)
            2'b00: 
                begin
                new_status[0] = addition_zero;
                new_status[1] = addition_auxiliary;
                new_status[2] = addition_carry;
                result = addition_result;
                end

            2'b01:
                begin
                new_status[0] = subtraction_zero;
                new_status[1] = subtraction_auxiliary;
                new_status[2] = subtraction_carry;
                result = subtraction_result;
                end
                
            2'b10:
                begin
                new_status[0] = inversion_zero;
                result = inversion_result;
                end

            2'b11:
                begin
                new_status[3] = comp_greater;
                new_status[4] = comp_less;
                new_status[5] = comp_equal;
                result = 8'h0;
                end
        endcase
    end

endmodule

