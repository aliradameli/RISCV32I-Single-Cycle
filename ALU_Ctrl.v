module ALU_Ctrl (
    input LookAtFnc,
    input [1:0] ALUopcTyp,
    input [2:0] func3, 
    input [6:0] func7,
    output reg [2:0] ALUFnc  // 3-bit output
);
    reg func;
    always @(LookAtFnc or ALUopcTyp or func3 or func7) begin
        // Default value
        ALUFnc = 3'b000;
        func = {func3, func7};
        parameter  ADD   = 12'h0_00,
                    SUB   = 12'h0_02,
                    AND   = 12'h7_00,
                    OR    = 12'h6_00, 
                    SLT   = 12'h2_00,
                    ADDI  = 4'h0, 
                    ORI   = 4'h6,
                    XORI  = 4'h4,
                    SLTI  = 4'h2,
                    BEQ   = 4'h0,
                    BNE   = 4'h1,
                    BLT   = 4'h4,
                    BGE   = 4'h5,
                    RTYPE = 2'b00,
                    ITYPE = 2'b01,
                    BTYPE = 2'b10;

        parameter ALU_ADD = 3'd0,
                   ALU_SUB = 3'd1,
                   ALU_AND = 3'd2,
                   ALU_OR  = 3'd3,
                   ALU_XOR = 3'd4,
                   ALU_SLT = 3'd5;         
        
        if (LookAtFnc) begin
            //R-type inst
            if (ALUopcTyp == RTYPE) begin
                case (func)
                    ADD: ALUFnc = ALU_ADD;
                    SUB: ALUFnc = ALU_SUB;
                    AND: ALUFnc = ALU_AND;
                    OR: ALUFnc = ALU_OR;
                    SLT: ALUFnc = ALU_SLT;
                    default : ALUFnc = 3'b000;
                endcase
            end
            //I-type inst 
            if (ALUopcTyp == ITYPE) begin
                case (func3)
                    ADDI: ALUFnc = ALU_ADD,
                    ORI: ALUFnc = ALU_OR,
                    XORI: ALUFnc = ALU_XOR,
                    SLTI: ALUFnc = ALU_SLT,
                    default: ALUFnc = 3'b000
                endcase
            end
            if (ALUopcTyp == BTYPE) begin
                case (func3)
                    BEQ = ALUFnc = ALU_SUB,
                    BNE = ALUFnc = ALU_SUB,
                    BLT = ALUFnc = ALU_SLT,
                    BGE = ALUFnc = ALU_SLT,
                    default: ALUFnc = 3'b000
                endcase
            end
        end
    end
endmodule