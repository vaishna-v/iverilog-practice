module fulladder_tb;

    reg a, b, c;
    wire sum, carry;


    fulladder uut(.a(a), .b(b), .c(c), .sum(sum), .carry(carry));
    integer i;

    initial
    begin
        $monitor("a = %b  b = %b  c = %b  |   carry = %b   sum = %b", a, b, c, carry, sum);

        for(i = 0; i < 8; i = i+1) 
            begin
                {a,b,c} = i;
                #10;
            end
    $finish;
    end

  


    

endmodule




