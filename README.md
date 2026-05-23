# Single-Cycle RISC-V Processor Design

[cite_start]This repository contains the design and hardware description implementation of a **Single-Cycle RISC-V Processor**[cite: 3]. [cite_start]The objective of this project is to structurally model the processor's datapath and behaviorally implement its control unit using **Verilog HDL**, followed by functional verification via simulation[cite: 24].

## Supported Instruction Set Architecture (ISA)

[cite_start]The processor supports a custom subset of standard RISC-V formats[cite: 3]:
* [cite_start]**R-Type:** `add`, `sub`, `and`, `or`, `slt` [cite: 7]
* [cite_start]**I-Type:** `lw`, `addi`, `xori`, `ori`, `slti`, `jalr` [cite: 10]
* [cite_start]**S-Type:** `sw` [cite: 13]
* [cite_start]**B-Type:** `beq`, `bne`, `blt`, `bge` [cite: 19]
* [cite_start]**J-Type:** `jal` [cite: 16]

---

## Architectural Implementation

The design is split into two primary components based on custom microarchitectural specifications:

### 1. Hardware Datapath
[cite_start]Implemented **structurally** in Verilog[cite: 24], routing data through modules including:
* A **32-bit Program Counter (PC)** and Instruction Memory.
* A **32-word Register File** (`REG File`) supporting dual asynchronous reads and synchronous writes.
* A multi-functional **Arithmetic Logic Unit (ALU)** executing arithmetic, bitwise, and comparison (`slt`) operations.
* **Data Memory** alongside dedicated sign/immediate extension units (`Imm Ext`).

### 2. Control Unit
[cite_start]Implemented **combinationally** [cite: 24] to dynamically decode instruction opcodes and generate proper routing signals (`ResultSrc`, `ALUSrc`, `RegWr`, `MemWr`). It includes multi-level ALU decoding logic (`ALUFnc`) and custom branch-evaluation circuitry handling conditional flags (`Zero`, `Slt`).

---

## Verification & Testing

[cite_start]To validate the behavioral accuracy of the processor, the hardware is simulated using a custom assembly program designed to sort a **10-element array of signed 32-bit integers**[cite: 20]. [cite_start]The design is verified against both custom and instructor-provided testbenches to guarantee complete compliance with the target ISA[cite: 24].
