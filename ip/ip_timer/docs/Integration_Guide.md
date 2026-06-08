# Integration Guide

## 1. Overview

This document describes how to integrate the Timer IP into a VSDSquadron FPGA SoC design.

The Timer IP is implemented as a memory-mapped peripheral and can be accessed by software running on the RISC-V processor through standard read and write transactions.

---

# 2. Required RTL Files

The following RTL file is required for integration:

```text
rtl/timer_ip.v
```

Include this file in the SoC build flow and synthesis project.

---

# 3. Timer IP Interface

The Timer IP exposes the following ports:

```verilog
module timer_ip (
    input            clk,
    input            resetn,

    input            sel,
    input            wr_en,
    input            rd_en,

    input  [1:0]     addr,
    input  [31:0]    wdata,

    output reg [31:0] rdata,
    output reg       timeout_o
);
```

## Signal Description

| Signal    | Direction | Description              |
| --------- | --------- | ------------------------ |
| clk       | Input     | System clock             |
| resetn    | Input     | Active-low reset         |
| sel       | Input     | Peripheral select        |
| wr_en     | Input     | Write enable             |
| rd_en     | Input     | Read enable              |
| addr      | Input     | Register address offset  |
| wdata     | Input     | Write data bus           |
| rdata     | Output    | Read data bus            |
| timeout_o | Output    | Timer timeout indication |

---

# 4. Instantiating the Timer IP

Instantiate the Timer IP inside the SoC peripheral section.

Example:

```verilog
timer_ip u_timer (
    .clk(clk),
    .resetn(resetn),

    .sel(timer_sel),
    .wr_en(timer_wr),
    .rd_en(timer_rd),

    .addr(timer_addr),
    .wdata(timer_wdata),

    .rdata(timer_rdata),
    .timeout_o(timeout_o)
);
```

The timer should be connected to the system bus alongside other memory-mapped peripherals.

---

# 5. Address Decoding

## Base Address

```text
0x20001000
```

## Address Range

```text
0x20001000 - 0x2000100F
```

## Register Mapping

| Address    | Register |
| ---------- | -------- |
| 0x20001000 | CTRL     |
| 0x20001004 | LOAD     |
| 0x20001008 | VALUE    |
| 0x2000100C | STATUS   |

---

## Example Address Decoder

```verilog
wire timer_sel =
    (mem_addr[31:4] == 28'h2000100);
```

Register offset generation:

```verilog
wire [1:0] timer_addr = mem_addr[3:2];
```

Offset decoding:

| timer_addr | Register |
| ---------- | -------- |
| 2'b00      | CTRL     |
| 2'b01      | LOAD     |
| 2'b10      | VALUE    |
| 2'b11      | STATUS   |

---

# 6. CPU Access Model

The RISC-V processor accesses the Timer IP using memory-mapped I/O.

### Write Example

```c
TIMER_LOAD = 1000000;
```

### Read Example

```c
value = TIMER_VALUE;
```

### Status Polling

```c
while((TIMER_STAT & 0x1) == 0);
```

No special bus protocol is required beyond the existing VSDSquadron peripheral interface.

---

# 7. Top-Level Signal Connections

The Timer IP generates a timeout output signal.

```verilog
output timeout_o;
```

This signal may be connected to:

* User LEDs
* GPIO outputs
* Header pins
* Future interrupt controller inputs

Example:

```verilog
assign LEDS[0] = timeout_o;
```

---

# 8. Board-Level Usage (VSDSquadron FPGA)

## Purpose

The timeout output allows the Timer IP to interact with external hardware connected to the FPGA.

When the timer expires:

```text
timeout_o = 1
```

This signal can be observed directly on LEDs or routed to expansion headers.

---

## LED Connection Example

Connect timeout output to an onboard LED.

```verilog
assign led_red = timeout_o;
```

Expected behavior:

### One-Shot Mode

* LED turns ON once when timer expires.
* LED remains ON until software clears the status.

### Periodic Mode

* LED toggles or blinks periodically depending on software implementation.

---

## Header Pin Connection

The timeout signal may also be exposed on FPGA expansion headers.

Example:

```verilog
assign header_pin_0 = timeout_o;
```

Possible uses:

* Oscilloscope monitoring
* Logic analyzer debugging
* External hardware triggering

---

# 9. Constraint File Requirements

No additional constraints are required for the Timer IP core itself.

Constraints are only required when the timeout output is connected to physical FPGA pins.

Example:

```text
set_io timeout_o <FPGA_PIN>
```

or

```text
set_io led_red <FPGA_PIN>
```

depending on the target VSDSquadron board design.

Refer to the board constraint file for the appropriate LED or header pin assignments.

---

# 10. Integration Checklist

Before synthesis, verify the following:

✔ timer_ip.v added to project

✔ Base address assigned

✔ Address decoder updated

✔ Timer instance connected

✔ Read data path connected

✔ timeout_o routed to desired output

✔ Software uses correct base address

✔ Design builds successfully

✔ Timer registers accessible from software

✔ Timeout behavior verified in simulation and hardware

---

# 11. Integration Data Flow

```text
                 RISC-V CPU
                      |
                      |
             Memory-Mapped Bus
                      |
                      v
              Address Decoder
                      |
                      v
                 Timer IP
                      |
                      v
                 timeout_o
                      |
          +-----------+-----------+
          |                       |
          v                       v
       LED Output          Header Pin
```

The Timer IP is now fully integrated and accessible from software running on the VSDSquadron RISC-V system.
