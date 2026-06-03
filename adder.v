module halfadder
(
    input a,
    input b,
    output carry,
    output sum
);
    assign carry = a&b;
    assign sum = a^b;
endmodule


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





module bit4adder            // or ripple adder
(
    input[3:0] a,    
    input[3:0] b,
    output[3:0] s,
    output[3:0] c
);

    // Add a0 and b0 using half adder
    halfadder ha(.a(a[0]), .b(b[0]), .sum(s[0]), .carry(c[0]));

    // a1 + b1 + c0
    fulladder fa(.a(a[1]), .b(b[1]), .c(c[0]), .sum(s[1]), .carry(c[1]));

    // a2 + b2 + c1    ==   sum = s2,  carry = c2
    fulladder fa1(.a(a[2]), .b(b[2]), .c(c[1]), .sum(s[2]), .carry(c[2]));

    // a3 + b3 + c2   ==   sum = s3,  carry = c3
    fulladder fa2(.a(a[3]), .b(b[3]), .c(c[2]), .sum(s[3]), .carry(c[3]));



endmodule