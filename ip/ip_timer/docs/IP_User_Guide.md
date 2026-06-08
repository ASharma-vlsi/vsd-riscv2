# Timer IP User Guide

## 1. IP Overview

### Purpose

The Timer IP is a programmable 32-bit countdown timer designed for integration into the VSDSquadron RISC-V SoC. It provides software-controlled timing functionality through a memory-mapped register interface, allowing software applications to generate delays, monitor elapsed time, and create periodic events.

### Typical Use Cases

* Software delay generation
* LED blinking applications
* Periodic task scheduling
* Event timing and measurement
* Timeout monitoring
* General-purpose timing functions in embedded systems

### Why/When to Use This IP

This IP should be used whenever an application requires accurate timing control without implementing software delay loops. By offloading timing operations to dedicated hardware, CPU resources remain available for other tasks while the timer operates independently.

Examples include:

* Generating fixed delays between operations
* Creating periodic events such as LED blinking
* Monitoring timeout conditions
* Implementing simple software schedulers

---

## 2. Feature Summary

### Supported Features

| Feature          | Description                   |
| ---------------- | ----------------------------- |
| Timer Width      | 32-bit countdown timer        |
| Operating Modes  | One-shot and Periodic         |
| Interface Type   | Memory-mapped registers       |
| Counter Reload   | Automatic in periodic mode    |
| Status Flag      | Timeout indication            |
| Software Control | Read/Write register interface |

### Supported Modes

#### One-Shot Mode

The timer counts down from the programmed value to zero and stops automatically after reaching zero.

#### Periodic Mode

The timer counts down to zero, reloads the programmed value automatically, and continues running indefinitely.

### Clock Assumptions

* Timer operates from the system clock supplied by the SoC.
* Timer resolution depends on the system clock frequency.
* Countdown occurs once per clock cycle.

### Limitations

* Single timer channel only
* No interrupt generation support
* Polling-based operation
* No programmable prescaler
* Maximum count limited to 32-bit register width
* Assumes a stable system clock source

---

## 3. Block Diagram

The Timer IP consists of a register interface, control logic, countdown counter, and status generation logic.

![Uploading image.png…]()

### Functional Flow

1. Software writes a value into the LOAD register.
2. Software configures the operating mode through the CTRL register.
3. The timer begins counting down when enabled.
4. When the counter reaches zero:

   * One-shot mode: timer stops.
   * Periodic mode: timer reloads automatically.
5. The timeout status flag is asserted to indicate timer expiration.

This architecture provides a lightweight and efficient timing solution suitable for embedded FPGA-based systems.

