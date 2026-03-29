# AES-128-VHDL-Accelerator
A cycle-accurate, hardware-optimized AES-128 encryption core implemented in VHDL with a 12-clock-cycle latency.
\## Overview

This repository contains a structural, hardware-optimized implementation of the Advanced Encryption Standard (AES-128) written in VHDL. Designed as a cycle-accurate RTL model, this core accepts a 128-bit secret key and a 128-bit plaintext block, applying the AES cryptographic algorithm to output a secure 128-bit ciphertext.



The architecture utilizes an \*\*iterative, 12-cycle latency design\*\*, demonstrating how to balance high-speed data throughput with efficient silicon area utilization in digital logic design.



\## Key Architectural Features

\* \*\*Iterative Datapath:\*\* Reuses a single `AES\_Round` module 10 times via a Finite State Machine (FSM), heavily optimizing the theoretical physical footprint.

\* \*\*12-Cycle Latency:\*\* Processes a full 128-bit block in 12 clock cycles from the `start` signal to the `done` flag.

\* \*\*Combinational Key Expansion:\*\* The key schedule is fully unrolled into a combinational logic tree, making all 11 round keys instantly available without sequential delay.

\* \*\*Parallel Substitution:\*\* S-Box lookups are generated concurrently to maximize combinational throughput.



\---



\## Hardware Architecture \& Module Breakdown



\### 1. The Controller (`AES\_Top`)

The top-level entity acts as the master synchronous controller. It houses the primary Finite State Machine (FSM) driven by standard `clk` and `rst` signals.

\* \*\*State Progression:\*\* `IDLE` -> `INIT\_ADD` -> `ROUND\_EXECUTE` (Iterates 10x) -> `FINISH`.

\* \*\*Design Choice:\*\* By looping the datapath through a single workstation, this design achieves a massive reduction in logic gates compared to a fully unrolled pipeline, trading a minimal 12-cycle delay for significant area savings.



\### 2. The Cryptographic Datapath (`AES\_Round`)

A structural wrapper that acts as the core assembly line. It instances the four standard AES transformations in sequence: `SubBytes` -> `ShiftRows` -> `MixColumns` -> `AddRoundKey`.

\* \*\*Design Choice:\*\* The AES specification requires the final (10th) round to omit the `MixColumns` step. This is handled via a hardware multiplexer that cleanly routes the datapath around the `MixColumns` block when the `is\_final\_round` flag is asserted.



\### 3. Core Transformations

\* \*\*`SubBytes` (Confusion):\*\* Replaces each byte using a non-linear substitution table (S-Box) using 16 parallel lookup tables.

\* \*\*`ShiftRows` (Diffusion):\*\* Cyclically shifts the rows of the data state using pure combinatorial wire routing (zero logic delay).

\* \*\*`MixColumns` (Heavy Diffusion):\*\* Performs Galois Field `GF(2^8)` matrix multiplication on each column to ensure a high avalanche effect.

\* \*\*`AddRoundKey`:\*\* Applies the active 128-bit round key via a 128-bit parallel bitwise XOR array.



\### 4. Key Schedule (`KeyExpansion`)

Generates the eleven 128-bit round keys required for the encryption process. Built entirely as combinational logic, the algorithm is unrolled into a sprawling logic tree that computes all 1,408 bits simultaneously.



\---



\## Simulation and RTL Schematics



This project was verified using standard VHDL simulation tools to ensure cryptographic accuracy against the FIPS-197 standard.



\### RTL Visualizations

\*(Note: Add your pictures of the RTL schematics or block diagrams here. For example: "Below is the RTL schematic generated for the top-level FSM and datapath routing.")\*



\* `\[Insert Image of AES\_Top RTL here]`

\* `\[Insert Image of AES\_Round datapath here]`



\### Waveform Verification

\*(Note: Add a screenshot of your simulation waveform here showing the 12-cycle execution).\*



\* `\[Insert Image of simulation waveform here]`

The waveform demonstrates the state transitions from `IDLE` through `ROUND\_EXECUTE` and the final assertion of the `done` signal alongside the valid `ciphertext`.



\---

\*Developed as an RTL design and hardware architecture portfolio project.\*
