module branch_Ctrl(
    input isBranch,
    input [2:0]func3, 
    input zero,
    input slt,
    output reg Branch
)
    always @(isBranch or func3 or zero or slt) begin
        //defualt value 
        Branch = 1'b0; 
        param  BEQ = 4'h0,
                    BNE = 4'h1,
                    BLT = 4'h4,
                    BGE = 4'h5;
        if (isBranch) begin
            case (func3)
                BEQ: Branch = zero;
                BNE: Branch = ~zero;
                BLT: Branch = slt;
            BGE: Branch = ~slt;
                default: Branch = 1'b0; 
            endcase
        end
    end
endmodule