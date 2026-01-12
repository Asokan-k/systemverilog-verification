# Dual Port RAM Verification – SystemVerilog

## Description
SystemVerilog-based verification environment for a synchronous dual port RAM.
The testbench is written without UVM to strengthen core SV verification concepts.

## DUT
- Synchronous Dual Port RAM
- Independent read and write ports

## Verification Environment
- Interface
- Transaction
- Generator
- Driver
- Monitor
- Reference Model
- Scoreboard
- Environment
- Test

## Features Verified
- Read and write operations
- Simultaneous dual-port access
- Read-after-write behavior
- Reset handling

## Methodology
- Directed and constrained-random testing
- Self-checking scoreboard
