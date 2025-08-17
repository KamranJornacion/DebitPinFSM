# Debit PIN Authentication FSM — Verilog + SystemVerilog/UVM

**What it is:**  
A hardware **Debit PIN authentication** flow built as a **finite state machine (FSM)** in Verilog. The design captures four one-hot digits, encodes them, compares against a parameterized passkey, and drives result flags (e.g., `correct`, `incorrect`, `waiting`, `bug`).  

**How it’s verified:**  
- **SystemVerilog procedural tests** (per-module): lightweight testbenches use generic tasks (e.g., `DigitSubmission`, `PasswordVerification`, `WrongPasswordVerification`, `ResetVerification`) to stimulate the DUTs, assert expected states/flags, and sanity-check internal counters/encodings.
  
- **UVM flow** (for selected DUTs): a small UVM environment (driver/seq/monitor/env/test) connects via **virtual interfaces** from `interface/` to the DUTs.

- **Verification plan alignment:** each test maps to the plan’s cases (reset behavior, digit capture/encode, correct vs. incorrect paths, verify pulse/counter, flag exclusivity). If timing optimizations shift sample edges, checks are re-aligned (not relaxed).


