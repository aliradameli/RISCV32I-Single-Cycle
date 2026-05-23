# Single-Cycle RISC-V Processor Design
![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![RISC-V](https://img.shields.io/badge/ISA-RISC--V-orange)
![Assembly](https://img.shields.io/badge/Language-RISC--V%20Assembly-red)

This repository contains the design and hardware description implementation of a **Single-Cycle RISC-V Processor**.The objective of this project is to structurally model the processor's datapath and behaviorally implement its control unit using **Verilog HDL**, followed by functional verification via simulation

## Supported Instruction Set Architecture (ISA)

The processor supports a custom subset of standard RISC-V formats:
* **R-Type:** `add`, `sub`, `and`, `or`, `slt`
* **I-Type:** `lw`, `addi`, `xori`, `ori`, `slti`, `jalr`
* **S-Type:** `sw`
* **B-Type:** `beq`, `bne`, `blt`, `bge`
* **J-Type:** `jal`

---

## Architectural Implementation

The design is split into two primary components based on custom microarchitectural specifications:

### 1. Hardware Datapath
Implemented **structurally** in Verilog, routing data through modules including:
* A **32-bit Program Counter (PC)** and Instruction Memory.
* A **32-word Register File** (`REG File`) supporting dual asynchronous reads and synchronous writes.
* A multi-functional **Arithmetic Logic Unit (ALU)** executing arithmetic, bitwise, and comparison (`slt`) operations.
* **Data Memory** alongside dedicated sign/immediate extension units (`Imm Ext`).

### 2. Control Unit
Implemented **combinationally** to dynamically decode instruction opcodes and generate proper routing signals (`ResultSrc`, `ALUSrc`, `RegWr`, `MemWr`). It includes multi-level ALU decoding logic (`ALUFnc`) and custom branch-evaluation circuitry handling conditional flags (`Zero`, `Slt`).

---

## Verification & Testing

To validate the behavioral accuracy of the processor, the hardware is simulated using a custom assembly program designed to sort a **10-element array of signed 32-bit integers**. The design is verified against both custom and instructor-provided testbenches to guarantee complete compliance with the target ISA.
