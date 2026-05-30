module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALU_Function,
    output reg [31:0] ALU_Out,
    output reg Zero,
    output reg Slt
);
        localparam  ALU_ADD = 3'd0,
                   ALU_SUB = 3'd1,
                   ALU_AND = 3'd2,
                   ALU_OR  = 3'd3,
                   ALU_XOR = 3'd4,
                   ALU_SLT = 3'd5;
    always @(A or B or ALU_Function) begin

        ALU_Out = 32'b0;
        Zero = 1'b0;
        Slt = 1'b0;

        case (ALU_Function)
            ALU_ADD: ALU_Out = A + B;                   // ADD
            ALU_SUB: ALU_Out = A - B;                   // SUB
            ALU_AND: ALU_Out = A & B;                   // AND
            ALU_OR:  ALU_Out = A | B;                   // OR
            ALU_SLT:  begin // SLT
                if (A[31] != B[31]) begin
                    if (A[31] > B[31]) begin
                        ALU_Out = 32'd1;
                    end else begin
                        ALU_Out = 32'd0;
                    end
                end else begin
                    if (A < B)
                    begin
                        ALU_Out = 32'd1;
                    end
                    else
                    begin
                        ALU_Out = 32'd0;
                    end
                end
			end
            ALU_XOR: ALU_Out = A ^ B;                   // XOR
            default: ALU_Out = 32'b0;                   // Default case
        endcase

        // Set Zero flag
        if (ALU_Out == 32'b0)
            Zero = 1'b1;
        else
            Zero = 1'b0;
        
        // Set Slt flag
        Slt = ALU_Out[0];
    end

endmodule