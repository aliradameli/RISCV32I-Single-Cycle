module ALU_Ctrl (
    input LookAtFnc,
    input [1:0] ALUopcTyp,
    input [2:0] func3, 
    input [6:0] func7,
    output reg [2:0] ALUFnc  // 3-bit output
);
    reg [9:0] func;
        parameter  ADD    = 10'b000_0000000,
                    SUB   = 10'b000_0100000,
                    AND   = 10'b111_0000000,
                    OR    = 10'b110_0000000, 
                    SLT   = 10'b010_0000000,
                    ADDI  = 3'b000, 
                    ORI   = 3'b110,
                    XORI  = 3'b100,
                    SLTI  = 3'b010,
                    BEQ   = 3'b000,
                    BNE   = 3'b001,
                    BLT   = 3'b100,
                    BGE   = 3'b101,
                    RTYPE = 2'b00,
                    ITYPE = 2'b01,
                    BTYPE = 2'b10;

        parameter ALU_ADD = 3'd0,
                   ALU_SUB = 3'd1,
                   ALU_AND = 3'd2,
                   ALU_OR  = 3'd3,
                   ALU_XOR = 3'd4,
                   ALU_SLT = 3'd5;  
    always @(LookAtFnc or ALUopcTyp or func3 or func7) begin
        // Default value
        ALUFnc = 3'b000;
        func = {func3, func7};
       
        if (LookAtFnc) begin
            case(ALUopcTyp)
                //R-type inst
                RTYPE: begin
                    case (func)
                        ADD: ALUFnc = ALU_ADD;
                        SUB: ALUFnc = ALU_SUB;
                        AND: ALUFnc = ALU_AND;
                        OR:  ALUFnc = ALU_OR;
                        SLT: ALUFnc = ALU_SLT;
                    endcase
                end
                //I-type inst 
                ITYPE: begin
                    case (func3)
                        ADDI: ALUFnc = ALU_ADD;
                        ORI:  ALUFnc = ALU_OR;
                        XORI: ALUFnc = ALU_XOR;
                        SLTI: ALUFnc = ALU_SLT;
                    endcase
                end
                BTYPE: begin
                    case (func3)
                        BEQ: ALUFnc = ALU_SUB;
                        BNE: ALUFnc = ALU_SUB;
                        BLT: ALUFnc = ALU_SLT;
                        BGE: ALUFnc = ALU_SLT;
                    endcase
                end
            endcase
            
        end
    end
endmodule