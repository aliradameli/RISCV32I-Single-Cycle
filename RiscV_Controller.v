module RiscV_Controller (

    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input zero,
    input slt,

    output [2:0] ALU_Function,
    output reg AluSrc,
    output reg [1:0] ResultSrc,
    output reg [2:0] ImmSrc,
    output reg RegWrite,
    output reg MemWrite,
    output reg [1:0] PCSrc
);

parameter R_T_OPCODE  = 7'd51,
          I_T_OPCODE  = 7'd19,
          SW_OPCODE   = 7'd35,
          LW_OPCODE   = 7'd3,
          BR_OPCODE   = 7'd99,
          JAL_OPCODE  = 7'd111,
          JALR_OPCODE = 7'd103;

reg LookAtFnc;
reg [1:0] ALUopcTyp;
reg isBranch;
reg [1:0] jumpOp;
always @(opcode)begin
    ResultSrc = 2'd0;
    AluSrc = 1'd0;
    ALUopcTyp = 2'd0;
    ImmSrc = 2'd0;
    RegWrite = 1'd0;
    MemWrite = 1'd0;
    LookAtFnc = 1'd0;
    PCSrc = 2'd0;


    case (opcode)
        R_T_OPCODE: begin 
            ResultSrc = 2'b00; 
            AluSrc    = 1'b0;
            RegWrite  = 1'b1; 
            MemWrite  = 1'b0; //DC
            LookAtFnc = 1'b1; 
            ALUopcTyp = 2'b00; 
            ImmSrc    = 2'b00;  //DC
            isBranch  = 1'b0; 
            jumpOp    = 2'b00; 
        end
        I_T_OPCODE: begin 
            ResultSrc = 2'b00; 
            AluSrc    = 1'b1;
            RegWrite  = 1'b1; 
            MemWrite  = 1'b0; 
            LookAtFnc = 1'b1; 
            ALUopcTyp = 2'b01; 
            ImmSrc    = 2'b00; 
            isBranch  = 1'b0; 
            jumpOp    = 2'b00; 
        end
        SW_OPCODE: begin 
            ResultSrc = 2'b00; //DC
            AluSrc    = 1'b1;
            RegWrite  = 1'b0; 
            MemWrite  = 1'b1; 
            LookAtFnc = 1'b0; //DC
            ALUopcTyp = 2'b00; 
            ImmSrc    = 2'b01; 
            isBranch  = 1'b0; 
            jumpOp    = 2'b00; 
        end
        LW_OPCODE: begin 
            ResultSrc = 2'b01; 
            AluSrc    = 1'b1;
            RegWrite  = 1'b1; 
            MemWrite  = 1'b0; 
            LookAtFnc = 1'b0; 
            ALUopcTyp = 2'b00; //DC
            ImmSrc    = 2'b00; 
            isBranch  = 1'b0; 
            jumpOp    = 2'b00; 
        end
        BR_OPCODE: begin 
            ResultSrc = 2'b00; //DC
            AluSrc    = 1'b0;
            RegWrite  = 1'b0; 
            MemWrite  = 1'b0; 
            LookAtFnc = 1'b1; 
            ALUopcTyp = 2'b10; 
            ImmSrc    = 2'b10; 
            isBranch  = 1'b1; 
            jumpOp    = 2'b00; 
        end
        JAL_OPCODE: begin 
            ResultSrc = 2'b10; 
            AluSrc    = 1'b0; //DC
            RegWrite  = 1'b1; 
            MemWrite  = 1'b0; 
            LookAtFnc = 1'b0; 
            ALUopcTyp = 2'b00; //DC
            ImmSrc    = 2'b11; 
            isBranch  = 1'b0; 
            jumpOp    = 2'b01; 
        end
        JALR_OPCODE: begin 
            ResultSrc = 2'b10; 
            AluSrc    = 1'b1;
            RegWrite  = 1'b1; 
            MemWrite  = 1'b0; 
            LookAtFnc = 1'b0; 
            ALUopcTyp = 2'b00; //DC
            ImmSrc    = 2'b00; 
            isBranch  = 1'b0; 
            jumpOp    = 2'b10; 
        end
    endcase





end
wire Branch;

always @(Branch or jumpOp)begin

    PCSrc = 2'b00;

    if (Branch || (jumpOp == 2'b01))begin
        PCSrc = 2'b01; // PC += imm
    end
    else if(jumpOp == 2'b10) begin
        PCSrc = 2'b10; // PC = rs1 + imm
    end
end

ALU_Ctrl alu_ctrl(
    .LookAtFnc(LookAtFnc),
    .ALUopcTyp(ALUopcTyp),
    .func3(func3), 
    .func7(func7),
    .ALUFnc(ALU_Function)
);

branch_Ctrl branch_ctrl(
    .isBranch(isBranch),
    .func3(func3), 
    .zero(zero),
    .slt(slt),
    .Branch(Branch)
);
endmodule