module register_file
(
    input clk,
    input write_enable,
    // two addresses: addr1, addr2
    input[2:0] read_addr1,
    input[2:0] read_addr2,

    output[2:0] write_addr,
    input[15:0] write_data,

    output[15:0] read_data1,
    output[15:0] read_data2
);

    // 8 registers, 16-bit each-
    reg[15:0] files[7:0];

    // Read-            // Asynchronous read
    assign read_data1 = files[read_addr1];
    assign read_data2 = files[read_addr2];

    // Synchronous Write-
    always @(posedge clk)
    begin
        if(write_enable)
            files[write_addr] <= write_data;
    end
endmodule