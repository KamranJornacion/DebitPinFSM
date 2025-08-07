# ✅ Verification Plan

---

## 1. Introduction

- **Design Name**: `PinCheck Module`
- **Purpose**: A FSM that takes user's pin input translated into signals via an encoder, and verifies if the pin matches the predefined key. One LED will turn on for 5 seconds if the password is incorrect, while another will turn on indefinitely if correct.
- **Verification Goal**: Ensure functional correctness using simulation-based verification.

---

## 2. Scope and Objectives

- **Scope**:
  - Verify reset behavior
  - Verify Hold LED logic
  - Verify output flag (LEDs) logic
  - Verify pin input logic

- **Out of Scope**:
  - Power modeling
  - Timing closure

- **Objectives**:
  - Validate expected output for known inputs
  - Catch functional bugs early
  - Achieve basic functional coverage

---

## 3. Verification Methodology

- **Method Used**: Simulation
- **Tool**: Icarus Verilog / ModelSim / Riviera-PRO
- **Language**: SystemVerilog (with/without UVM)
- **Strategy**:
  - Directed testing
  - Manual waveform inspection
  - Constrained random testing
- **Testbench Style**: Procedural or modular, depending on use of UVM

---

## 4. Testbench Architecture

- **Components**:
  - DUT instantiation
  - Clock generator
  - Reset logic
  - Monitor
  - Driver (optional)
  - Sequence controller (optional)

- **Interface Signals**:
  - `clk`: Clock input
  - `reset`: Reset signal
  - `submit`: Submit one digit from password signal
  - `digit`: Databus input from encoder
  - `waiting, correct, incorrect, bug`: Flags (LEDs) to indicate state of FSM



---

## 5. Test Plan / Test Cases

| **Test Case ID** | **Name**           | **Description**                                | **Expected Result**                          | **Pass/Fail Criteria**                |
|------------------|--------------------|------------------------------------------------|----------------------------------------------|----------------------------------------|
| TC1              | Reset Test         | Apply reset and observe state and Flags      | `state =` `correct =` `incorrect =` `dig_count =` `bug = 0` | Pass if all values reset correctly    |
| TC2              | Digit Submission  | Deassert reset, pass a digit to the encoder, submit and observe passkey progression  | `Digit Count = 0` until `Submit = 1` and `firstDigit` then `secondDigit` toggles, then `4` | Pass if passkey flags transitions as expected    |
| TC3              | Correct Password Test    |                        |        |         |
[//]: <> (Incomplete, continue appending testcases)
---


## 6. Coverage Metrics

- **Code Coverage**: Line and branch (viewed via simulator)
- **Functional Coverage** (optional): Basic signal transitions and edge conditions
- **Goals**:
  - Line coverage ≥ 90%
  - 100% test case pass rate

---
