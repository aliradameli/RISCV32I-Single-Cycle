module instMem (
    input [31:0] addr,           
    output reg [31:0] inst    
);

    // Define a memory array of 1024 words (4KB)
    reg [31:0] instMem [0:1023];
    integer i;
    initial begin
        // Initialize memory to zero

        for (i = 0; i < 1024; i = i + 1) begin
            instMem[i] = 32'b0;
        end
        $readmemb("instmem.txt",instMem,0,18);
    end

    always @(addr) begin
        inst = instMem[addr[11:2]]; // Use bits [11:2] for woinst addressing
    end
endmodule