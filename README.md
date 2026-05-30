# Single-Cycle RISC-V Processor Design
![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![RISC-V](https://img.shields.io/badge/ISA-RISC--V-orange)
![Assembly](https://img.shields.io/badge/Language-RISC--V%20Assembly-red)
![Collabrator ID](https://github.com/amirmy1382)

A comprehensive, high-performance hardware implementation of a 32-bit single-cycle RISC-V processor core written from the ground up in structural and combinational Verilog HDL. Designed to adhere strictly to the microarchitectural constraints of modular layout configurations, this processor maps complex instruction fields directly to execution paths within a single clock cycle. It operates efficiently on a specialized subset of the RV32I base integer instruction set, striking an ideal balance between minimal propagation delay and hardware efficiency.

---

## Supported Instruction Set Architecture (ISA)

The microarchitecture fully implements a tailored subset of standard RISC-V specifications, encompassing computational R-type blocks, immediate arithmetic operations, direct memory tracking formats, conditional software branching logic, and unconditional control-flow jumps:

* **R-Type (Register-to-Register):** `add`, `sub`, `and`, `or`, `slt` 
  * Core arithmetic and bitwise logical operations execution utilizing values purely held within the internal register file.
* **I-Type (Immediate & Load Operations):** `lw`, `addi`, `xori`, `ori`, `slti`, `jalr` 
  * Computations involving a register and an encoded 12-bit sign-extended immediate value, alongside memory reading and indirect jump control paths.
* **S-Type (Store Operations):** `sw`
  * Outbound data transactions migrating register states directly into targeted synchronous blocks within the main data memory.
* **B-Type (Conditional Branching):** `beq`, `bne`, `blt`, `bge` 
  * Hardware evaluation of condition flags to alter the sequential program flow dynamically based on relative signed boundaries.
* **J-Type (Unconditional Long-Range Jumps):** `jal` 
  * PC-relative unconditional control transfer combined with link-register address storage for procedural calls.

---

## Architectural Breakdown & Module Specifications

The processor core is structurally divided into two primary logical abstractions: a pipeless **Structural Datapath** which handles physical data flow, value mutation, and architectural storage updates; and a pure **Combinational Control Unit** which handles parallel instruction field decoding and generates runtime routing signals.

### 1. Advanced Structural Datapath Components

* **Program Counter (PC) Framework:**
  An edge-triggered 32-bit register storing the immediate memory address of the current execution pointer. It updates synchronously on the rising edge of the system clock signal, parsing choices supplied by a multi-channel multiplexer array governed by the runtime status of the `PCSrc` control bus.

* **Instruction Memory (Inst Mem) Interface:**
  A word-addressable static lookup memory block. It accepts the 32-bit address vector from the Program Counter and combinationally emits the corresponding 32-bit raw machine-code instruction payload onto the main routing fabric.

* **Register File (REG File) Architecture:**
  A multi-ported synchronous internal storage array composed of 32 general-purpose 32-bit registers. To maintain throughput, it supports dual fully asynchronous combinational read operations (`RdData1`, `RdData2`) driven directly by source field identifiers `[19:15]` (rs1) and `[24:20]` (rs2). Write-back procedures (`WrData`) occur synchronously on the active clock edge targeting the destination register specified by bits `[11:7]` (rd), provided the `RegWr` control bit is actively asserted.

* **Immediate Extension Unit (Imm Ext):**
  A combinational steering module that extracts disparate immediate bit slices scattered across various instruction formats and aligns them into clean, uniform 32-bit sign-extended entities. The unit relies on a 2-bit selection input (`ImmSrc`) to dynamically reorganize the slicing parameters to match I, S, B, or J mapping alignments.

* **Arithmetic Logic Unit (ALU) Core:**
  The central computational powerhouse processing two 32-bit source elements. Operand A is bound to the primary register read line (`RdData1`), while Operand B is conditionally routed through a downstream multiplexer steered by `ALUSrc` to select between secondary register data (`RdData2`) or the sign-extended immediate vector. The unit yields a 32-bit transformation result (`ALUOUT`) alongside independent, dedicated condition-evaluation flags (`Zero`, `Slt`) to feed branching decisions.

* **Data Memory Management:**
  An internal storage module mapping the volatile data space of the processor. It interacts with the pipeline utilizing an address bus derived directly from the primary `ALUOUT` line. It supports synchronous write operations when `MemWr` is high and exposes read data asynchronously back to the write-back multiplexer stack based on the decoded memory matrix.

### 2. Combinational Control & Logic Units

* **Main Decoder Matrix:**
  Evaluates the fundamental instruction opcode (`Opc`) to establish base execution variables, steering memory routing paths (`ResultSrc`), execution source inputs (`ALUSrc`), and storage permission flags (`RegWr`, `MemWr`).

* **ALU Function Decoder:**
  Translates the combinational operational states (`ALUOpcTyp`) alongside instruction sub-fields `func3` and `func7` into explicit 3-bit operational directives (`ALUFnc`) when permitted by the `LookAtFnc` conditional logic.

* **Branch Condition Evaluator:**
  Inspects branch-type bits (`func3`) concurrently with live hardware flags (`Zero`, `Slt`) under an active `IsBranch` state to immediately resolve conditional control jumps.

---

## Microarchitectural Control Matrix

The core operations are governed entirely by the following control matrix, which defines how the combinational control unit orchestrates signal routing across the datapath:

| Instruction Class | Opcode (`Opc`) | `ResultSrc` | `ALUSrc` | `MemWr` | `RegWr` | `LookAtFnc` | `ALUOpcTyp` | `ImmSrc` | `IsBranch` | `JumpOp` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **R-Type** | 51 | 00 | 0 | 0 | 1 | 1 | 00 | - | 0 | 00 |
| **S-Type (`sw`)** | 35 | - | 1 | 1 | 0 | 0 | - | 01 | 0 | 00 |
| **I-Type** | 19 | 00 | 1 | 0 | 1 | 1 | 01 | 00 | 0 | 00 |
| **Load (`lw`)** | 3 | 01 | 1 | 0 | 1 | 0 | - | 00 | 0 | 00 |
| **Branch** | 99 | - | 0 | 0 | 0 | 1 | 10 | 10 | 1 | 00 |
| **`jal`** | 111 | 10 | - | 0 | 1 | 0 | - | 11 | 0 | 01 |
| **`jalr`** | 103 | 10 | 1 | 0 | 1 | 0 | - | 00 | 0 | 10 |

### Arithmetic Logic Unit Functions (`ALUFnc`)

When individual instruction sub-fields are parsed by the execution unit under active decoding, the 3-bit `ALUFnc` bus resolves to the following operations:
* `000`: Addition (`add` / `addi` / structural offset calculation)
* `001`: Subtraction / Comparison (`sub` / conditional checking sequences)
* `010`: Bitwise AND (`and`)
* `011`: Bitwise OR (`or` / `slti`)
* `100`: Bitwise XOR (`xori`)
* `101`: Set Less Than (`slt`)

### Program Counter Control Logic (`PCSrc`)

The next program address calculation selects from three distinct structural branches based on current operational demands:
* **`PCSrc = 01` ($PC + 4$ or $PC + \text{Imm}$):** Standard sequential instruction increments or relative long-range jumps (`jal`).
* **`PCSrc = 10` ($\text{ALUOUT}$):** Absolute register-indexed target jumps, calculated from register data plus an immediate offset (`jalr`).
* **`PCSrc = 00` (Fallback State):** Default non-executed branch tracking condition.

---

## Verification Program: In-Memory Signed Integer Sorting

To validate the operational correctness, cycle timing, and signal integrity of the complete single-cycle implementation under standard operating parameters, the design is verified against an integrated hardware testing routine: [cite: 20]

* [cite_start]**Functional Objective:** The processor core executes an assembly application program that implements an in-memory sorting algorithm (such as bubble sort or selection sort) targeting a contiguous 10-element array of signed 32-bit integers. [cite: 20]

* **Instruction Coverage & Stress Profile:** The program is systematically structured to exercise the processor's control matrix heavily. It utilizes conditional loops and status boundaries via branch variants (`blt`, `bge`, `bne`, `beq`), performs active array element swapping using memory load-store paths (`lw`, `sw`), and computes running index modifications through pointer manipulation commands (`addi`, `add`). [cite_start]Passing this verification setup guarantees that all structural paths, multiplexer selectors, and flag generation lines inside the control unit operate in harmony.
