# ✅ Verification Plan

---

## 1. Introduction

- **Design Name**: `DebitPin Module`
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

- **Signals**:
  - `clk`: Clock input
  - `reset`: Reset signal
  - `submit`: Submit one digit from password signal
  - `digit`: Databus input from encoder
  - `waiting, correct, incorrect, bug`: Flags (LEDs) to indicate state of FSM



---

## 5) Test Plan / Test Cases

| **TC ID** | **Name** | **Description / Stimulus** | **Expected Result** | **Pass/Fail Criteria** |
|---|---|---|---|---|
| **TC1** | Reset Sanity | Apply reset in `initial` and between tasks. | FSM → IDLE (`state==0`); flags cleared (`correct==0`, `incorrect==0`, `bug==0`). | Post-reset asserts pass. |
| **TC2** | Digit Capture & Encoding | `DigitSubmission()`: for many attempts, drive 4 random **valid one-hot** digits (`1000/0100/0010/0001`) with `submit` pulses. | DUT encodes each digit and shifts into `pinchk.password[7:0]` in order. | `encode(d3)==password[7:6]`, `encode(d2)==password[5:4]`, `encode(d1)==password[3:2]`, `encode(d0)==password[1:0]`. |
| **TC3** | Correct Password Path | `PasswordVerification()`: send the decoded `passkey` digits (MS nibble → LS nibble). | After 4th digit: `dig_count==4` → next cycle `dig_count==0`, `verify==1`, `waiting==0`; states `3` (CORRECT) → `5` (DONE); flags `correct==1`, `incorrect==0`, `bug==0`. | All in-task asserts at specified `@(negedge clk)` checkpoints pass. |
| **TC4** | Incorrect Password Path | `WrongPasswordVerification()`: random `attempt != passkey`, decode to digits, send sequence. | After 4th digit: `dig_count==4` → next `dig_count==0`, `verify==1`, `waiting==0`; states `4` (INCORRECT) → `5` (DONE); flags `correct==0`, `incorrect==1`, `bug==0`. | All in-task asserts pass across multiple attempts. |
| **TC5** | Mid-Entry Reset Sweep | `ResetVerification()`: for `i=0..17`, fork threads: one asserts `reset` after `i` half-cycles while the other is entering a randomized attempt; `join_any`/`disable` remainder. | Any-phase reset forces IDLE and clears flags; if reset **doesn’t** preempt, behavior reduces to TC3/TC4 based on `attempt`. | Reset-branch asserts pass (`state==0`, flags cleared). Non-reset branch meets TC3/TC4 checks. |
| **TC6** | Verify Pulse & Counter | Covered in TC3/TC4: observe `dig_count` reaching 4, auto-clearing to 0, and a single-cycle `verify==1`; `waiting==0` during verify. | Correct pulse/counter behavior. | Existing asserts in TC3/TC4 pass. |
| **TC7** | Parameterization Sanity | Implicit: `passkey` is an 8-bit (4×2-bit) parameter. | Only the exact parameterized key yields CORRECT path. | TC3 passes; TC4 consistently yields INCORRECT. |
| **TC8** | Flag Exclusivity at DONE | Observe flags at state `5`. | Exactly one of `correct`/`incorrect` is 1; `bug==0`. | Final asserts in TC3/TC4 pass. |
| **TC9** | No Spurious `bug` | Across all runs. | `bug==0` always. | No assertion hits on `bug`. |
| **TC10** | LED Hold Duration (Manual) | If INCORRECT path drives a hold (e.g., “5s” → N cycles), check waveforms for duration and clean release. | LED/flag holds for expected cycles, then clears. | Visual confirmation; document N cycles used. |

---


## 6. Coverage Metrics

- **Code coverage:** Line/branch via simulator; **goal ≥ 90%**.
- **Functional coverage (lightweight, optional):**
  - States covered: `0`, `3`, `4`, `5`
  - `attempt == passkey` vs `attempt != passkey`
  - Cross: reset timing (digit index 0/1/2/3 entered) × result path (correct/incorrect)
  - All valid one-hot digits used in each of the 4 positions

---

## 7) Traceability (Features → Tests)

- Digit capture & encode → **TC2**
- Correct path → **TC3**
- Incorrect path → **TC4**
- Verify pulse & counter → **TC3/TC4/TC6**
- Reset (power-on & mid-entry) → **TC1/TC5**
- Flag exclusivity & no-bug → **TC8/TC9**
- LED hold timing → **TC10**

---

## 8) Pass/Fail Definition

- **PASS:** All task-level assertions hold for a full run of `DigitSubmission`, `PasswordVerification`, `WrongPasswordVerification`, and `ResetVerification`; no unexpected `$fatal`; optional waveform checks match expected timing.
- **FAIL:** Any assertion violation or observable mismatch against the expected state/flag sequences.

---