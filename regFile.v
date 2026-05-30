module regFile  (
    input [4:0] RdAdrr1,
    input [4:0] RdAdrr2,
    input [4:0] WrAdrr,
    input [31:0] WrData,
    input WrEn,
    input clk,
    output reg [31:0] RdData1,
    output reg [31:0] RdData2
);

    reg [31:0] regArray [0:31];
    integer i;
    initial begin

        for (i = 0; i < 32; i = i + 1) begin
            regArray[i] = 32'b0;
        end
    end

    always @(RdAdrr1 or RdAdrr2 or WrEn or WrAdrr or WrData) begin

        RdData1 = regArray[RdAdrr1];
        RdData2 = regArray[RdAdrr2];
    end

    always @(posedge clk)begin
      
        if (WrEn) begin
            if (WrAdrr != 5'd0)begin
                
                regArray[WrAdrr] <= WrData;
            end
        end
    end
endmodule