module RiscV_Processor (
    input clk , 
    input rst
);
    wire [2:0] ALU_Function;
    wire AluSrc;
    wire ResultScr;
    wire ImmScr;
    wire RegWrite; 
    wire MemWrite;
    wire PCSrc ;
    wire zero ;
    wire [6:0] opcode;
    wire [2:0] func3;
    wire [6:0] func7;
    wire slt;

    RiscV_Datapath riscv_datapath(
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .zero(zero),
        .slt(slt),
        .ALU_Function(ALU_Function),
        .AluSrc(AluSrc),
        .ResultScr(ResultScr),
        .ImmScr(ImmScr),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .clk(clk),
        .rst_(rst)
    );
        RiscV_Controller riscv_controller(
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .zero(zero),
        .slt(slt),
        .ALU_Function(ALU_Function),
        .AluSrc(AluSrc),
        .ResultScr(ResultScr),
        .ImmScr(ImmScr),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc)
    );
endmodule