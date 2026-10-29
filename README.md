# Digital Combination Lock - Hardware Design Project (IL2234)

A modular, hardware-based digital lock system featuring a 4-digit hexadecimal passcode configuration, developed as a project task for the course **IL2234 Digital Design** at KTH Royal Institute of Technology. The system manages a secure locking mechanism with sequential validation logic using Finite State Machines (FSM) and deployed FPGA hardware peripherals.

## Hardware Platform
* **Target Platform:** FPGA Development Board (driven by a 100 MHz primary clock)
* **Shield/Peripherals:** Hardware switches (simulating keypad entry for 4-bit hex values) and push buttons (for input validation)
* **Display:** Onboard LEDs (mapped to signal the Locked and Unlocked system states)

## Features & Implementation Details
This repository contains the complete independent implementation of **Assignment 2** from the course specification, ensuring fully integrated logic across all components.

* **Task 2a: Digital Lock FSM Core**
  * Implemented a comprehensive security state machine managing system states (Locked vs. Unlocked).
  * Supports runtime configuration: Locking via a dedicated key (`Key B`), sequential 4-digit passcode verification followed by an unlock key (`Key C`), and dynamic user-passcode reprogramming (`Key E`).

* **Task 2b: Hardware Integration & Debouncing**
  * Developed a hardware debouncing register running on a divided low-frequency clock (100 Hz) to sample and stabilize the raw input, eliminating mechanical switch noise.
  * Integrated a synchronous, two-state Edge Detector FSM (Released/Pressed) to capture input transitions and assert a clean, single-clock-cycle pulse exactly on the rising edge of a valid key press.

## Repository Structure
* Root Directory (`/`) - Contains all core design files, including VHDL/Verilog source code, state machine definitions, and top-level wrappers.
* `/constraints` - Contains the board-specific hardware constraint files (XDC/PCF) mapping the design pins to the physical FPGA switches, buttons, and LEDs.

## Tech Stack & Development Tools
* **Language:** VHDL / Verilog (Hardware Description Language)
* **IDE:** FPGA Design Suite / Synthesis Tool
* **Framework:** Register-Transfer Level (RTL) Architecture
* **Methodology:** Finite State Machine (FSM) Design
