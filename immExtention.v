module immExtention (
    input [31:7] inst,
    input [2:0]  immSrc,
    output reg [31:0] imm32
);
    parameter I_TYPE_SRC = 3'd0, 
               S_TYPE_SRC = 3'd1,
               Branch_SRC = 3'd2,
               J_TYPE_SRC = 3'd3; 

    always @(immSrc or inst)begin
        imm32 = 32'd0;

        case (immSrc)
            I_TYPE_SRC: imm32 = {{20{inst[31]}}, inst[31:20]};                   
            S_TYPE_SRC: imm32 = {{20{inst[31]}}, inst[31:25], inst[11:7]};                   
            Branch_SRC: imm32 = {{20{inst[31]}}, inst[31],    inst[7],    inst[30:25],inst[11:8], 1'b0};                  
            J_TYPE_SRC: imm32 = {{12{inst[31]}}, inst[19:12], inst[20],   inst[30:21], 1'b0};                    
            default:    imm32 = 32'b0;                   
        endcase

    end
endmodule