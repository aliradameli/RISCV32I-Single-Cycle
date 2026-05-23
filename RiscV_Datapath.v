module RiscV_Datapath (
    input clk,
    input rst_,
    // Control signals
    input [2:0] ALU_Function,
    input AluSrc,
    input [1:0] ResultSrc,
    input [1:0] ImmSrc,
    input RegWrite,
    input MemWrite,
    input PCSrc,
    output [6:0] opcode,
    output [2:0] func3,
    output [6:0] func7,
    output  zero,
    output  slt
);

    reg [31:0] PC;
    wire [31:0] next_PC;
    // Instruction and data memory interfaces
    wire [31:0] instruction;
    reg_32bit pc_reg (
        .clk(clk),
        .rst_(rst_),
        .Q(next_PC),
        .D(PC)
    );

    instMem instr_mem (
        .addr(PC),
        .inst(instruction)
    );

    wire [4:0] rs1, rs2, rd;
    wire [6:0] opcode;
    wire [2:0] func3;
    wire [6:0] func7;
    // Instruction fields
    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign func3 = instruction[14:12];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign func7 = instruction[31:25];
    
    wire [31:0] read_data1, read_data2;
    wire [31:0] regResult;
    regFile reg_file(
        .RdAdrr1(rs1),
        .RdAdrr2(rs2),
        .WrAdrr(rd),
        .WrData(regResult),
        .RdData1(read_data1),
        .RdData2(read_data2),
        .WrEn(RegWrite),
        .clk(clk)
    );

    wire [31:0] imm_ext;
    immExtention  imm_extention(
        .inst(instruction[31:7]),
        .immSrc(ImmSrc),
        .imm32(imm_ext)
    );


    parameter ALUSRC_IMM = 1'b1,
               ALUSRC_REG = 1'b0; 
    wire [31:0] alu_src_b;
    assign alu_src_b = (AluSrc == ALUSRC_IMM) ? imm_ext :
                       (AluSrc == ALUSRC_REG) ? read_data2 : 32'b0;

    wire [31:0] alu_out;
    ALU alu (
        .A(read_data1),
        .B(alu_src_b),
        .ALU_Function(ALU_Function),
        .ALU_Out(alu_out),
        .Zero(zero),
        .Slt(slt)
    );

    wire [31:0] mem_read_data;
    dataMem (
        .addr(alu_out),     
        .WD(read_data2),    
        .WrEn(MemWrite),               
        .RD(mem_read_data),
        .clk(clk)    
    );
    parameter RESULTSRC_ALU = 2'b00,
            RESULTSRC_MEM = 2'b01,
            RESULTSRC_PC_PLUS_4 = 2'b10;

    wire [31:0] pc_jalr , pc_plus_4, pc_plus_imm;

    assign regResult = (ResultSrc == RESULTSRC_ALU) ? alu_out :
                       (ResultSrc == RESULTSRC_MEM) ? mem_read_data :
                       (ResultSrc == RESULTSRC_PC_PLUS_4) ? pc_plus_4
                       : 32'b0;

    wire [31:0] pc_jalr, pc_plus_imm;

    adder a1(PC, 4, pc_plus_4);
    adder a2(PC, imm_ext, pc_plus_imm);
    assign pc_jalr = alu_out;

    parameter PCSRC_PC_PLUS_4    = 2'b00,
               PCSRC_PC_PLUS_IMM  = 2'b01,
               PCSRC_JALR         = 2'b10;

    assign next_PC = (PCSrc == PCSRC_PC_PLUS_4) ? pc_plus_4 :
                     (PCSrc == PCSRC_PC_PLUS_IMM) ? pc_plus_imm :
                     (PCSrc == PCSRC_JALR) ? pc_jalr 
                     : 32'b0;
endmodule