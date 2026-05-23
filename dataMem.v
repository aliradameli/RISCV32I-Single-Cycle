module dataMem (
    input [31:0] addr,     
    input [31:0] WD,    
    input WrEn,               
    input clk,
    output reg [31:0] RD    
);

    // Define a memory array of 1024 words (4KB)
    reg [31:0] mem [0:1023];
    initial begin
        // Initialize memory to zero
        integer i;
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'b0;
        end
        $readmemh("datamem.txt",mem,0,9)
    end

    always @(addr) begin
        RD = mem[addr[11:2]]; // Use bits [11:2] for word addressing
    end

    always @(posedge clk) begin
        if(WrEn)begin
            mem[addr[11:2]] <= WD;
        end
    end
endmodule