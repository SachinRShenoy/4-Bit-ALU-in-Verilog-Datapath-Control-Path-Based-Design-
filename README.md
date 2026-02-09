# 4-Bit ALU in Verilog (Datapath & Control-Path Based Design)

## Overview

This repository implements a **4-bit Arithmetic Logic Unit (ALU)** in Verilog using a **clear separation of datapath and control path**, similar to how real processors are designed.

The ALU supports arithmetic, logical, shift, and comparison operations, along with **status flags** (Zero, Sign, Overflow).  
The design is **purely combinational**, synthesizable, and verified using a comprehensive testbench.

## File Structure
```
├── design.sv        
├── testbench.sv     
├── README.md
└── waveforms
```

This project is intended for:
- Digital Design / Computer Architecture learning
- Understanding datapath vs control-path separation
- FPGA / ASIC foundational ALU design
- Lab records, viva preparation, and GitHub portfolio

---

## Features

- 4-bit signed ALU (two’s complement)
- Separate **control unit**, **datapath**, and **result/flag multiplexer**
- Parallel computation of all operations
- Correct **signed overflow detection**
- Status flags:
  - Zero Flag (ZF)
  - Sign Flag (SF)
  - Overflow Flag (OF)
- Fully verified with testbench and GTKWave

---

## Supported Operations

| Opcode | Operation              | Description |
|------|------------------------|-------------|
| 000  | ADD                    | Signed addition |
| 001  | SUB                    | Signed subtraction |
| 010  | AND                    | Bitwise AND |
| 011  | OR                     | Bitwise OR |
| 100  | Arithmetic Right Shift | Sign-extended right shift |
| 101  | Arithmetic Left Shift  | Left shift |
| 110  | Comparator             | A > B, A < B, A == B |
| 111  | Reserved               | Not used |

---

## Output Encoding (Comparator)

When `opcode = 110`:

| Condition | Result |
|---------|--------|
| A > B   | `0100` |
| A < B   | `0010` |
| A == B  | `0001` |

---

## Status Flags

| Flag | Meaning |
|----|--------|
| ZF | Set when result = `0000` |
| SF | MSB of result (sign bit) |
| OF | Signed overflow (ADD/SUB only) |

### Overflow Logic

Overflow is meaningful **only for signed arithmetic**.

- **Addition**  
  Overflow when operands have the same sign and the result has a different sign

- **Subtraction**  
  Overflow when operands have different signs and the result sign differs from A

Implemented using sign-bit logic:

```verilog
OF_add = (~(A[3] ^ B[3])) & (A[3] ^ addsum[3]);
OF_sub = (A[3] ^ B[3]) & (A[3] ^ subdif[3]);
```

## Architecture

### 1. Control Path (`alu_ctrl`)

- Decodes the 3-bit opcode  
- Generates internal control signal (`alu_ctr`)  
- Contains **no arithmetic or data manipulation**

---

### 2. Datapath (`alu_data`)

- Computes **all operations in parallel**
- Contains **no opcode-based decision logic**
- Generates:
  - Arithmetic results
  - Logical results
  - Shift results
  - Comparator output
  - Overflow candidates (`OF_add`, `OF_sub`)

---

### 3. Result & Flag Multiplexer (`alu_mux`)

- Selects the correct result based on the control signal
- Generates:
  - **ZF** from the selected result
  - **SF** from the MSB of the selected result
  - **OF** from the selected arithmetic operation

---

### 4. Top Module (`ALU_4bit`)

- Instantiates control path, datapath, and multiplexer
- Acts as a **pure interconnection module**
- Contains **no internal logic**

---

## Datapath vs Control-Path Philosophy

### Datapath

- Computes all possible results **continuously and in parallel**
- Includes:
  - Adder
  - Subtractor
  - Logic unit
  - Shifter
  - Comparator

### Control Path

- Decides **which result and flags are valid**
- Performs no arithmetic

This mirrors how real CPU ALUs are implemented and avoids recomputation.

---

## How to Simulate (EDA Playground)

1. Open: https://edaplayground.com  
2. Select:
   - **Language**: Verilog / SystemVerilog  
   - **Simulator**: Icarus Verilog  
3. Paste:
   - ALU code into `design.sv`
   - Testbench into `testbench.sv`
4. Enable:
   - **Open EPWave after run**
5. Run the simulation

---

## GTKWave Signals to Observe

- **Inputs**:  
  `A`, `B`, `op_code`

- **Datapath signals**:  
  `addsum`, `subdif`, `andout`, `orout`, `rshiftt`, `lshiftt`, `compp`

- **Control signal**:  
  `alu_ctr`

- **Outputs**:  
  `result`, `ZF`, `SF`, `OF`

This clearly demonstrates **parallel datapath computation** and **control-based selection**.

---

## Testbench Coverage

The testbench verifies:

- Normal arithmetic operations
- Signed overflow cases
- Negative number handling
- Zero detection
- Logical correctness
- Shift correctness
- Comparator correctness
- Correct flag behaviour for all operations

### Example Overflow Test Cases

- `7 + 3`
- `-8 + -8`
- `7 - (-1)`
- `-8 - 1`

---

## Synthesis Notes

- Fully combinational design
- No clocks or latches
- Synthesizable on FPGA
- Suitable as a base for:
  - 8-bit / 16-bit ALU
  - CPU datapath
  - Pipelined architectures

---

## Future Enhancements

- Carry Flag (CF)
- Single shared ADD/SUB adder
- Restricted shift amount (`B[1:0]`)
- Parameterized bit-width
- Integration into a simple CPU

---

## Author Notes

This project was developed incrementally to deeply understand:

- Datapath vs control-path separation
- Signed arithmetic behaviour
- Overflow detection
- Clean Verilog design practices

It reflects **real hardware-oriented thinking**, not just behavioural coding.

