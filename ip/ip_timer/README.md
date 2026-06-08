# Timer IP for VSDSquadron FPGA

## Overview

The Timer IP is a 32-bit memory-mapped countdown timer designed for integration into the VSDSquadron RISC-V SoC.

It provides hardware-based timing functionality for:

* Delay generation
* Periodic events
* LED blinking
* Timeout monitoring
* Embedded software timing applications

Supported modes:

* One-Shot Mode
* Periodic Mode

---

## Directory Structure

```text
timer_ip/
├── rtl/
│   └── timer_ip.v
│
├── software/
│   └── timer_test.c
│
├── docs/
│   ├── IP_User_Guide.md
│   ├── Register_Map.md
│   ├── Integration_Guide.md
│   └── Example_Usage.md
│
└── README.md
```

---

## Quick Integration

### 1. Add RTL File

Include:

```text
rtl/timer_ip.v
```

in the VSDSquadron SoC build.

### 2. Instantiate the IP

Instantiate the Timer IP inside the peripheral section of the SoC.

### 3. Allocate Address Space

Base Address:

```text
0x20001000
```

Register Map:

| Address    | Register |
| ---------- | -------- |
| 0x20001000 | CTRL     |
| 0x20001004 | LOAD     |
| 0x20001008 | VALUE    |
| 0x2000100C | STATUS   |

### 4. Connect Output

Connect:

```verilog
timeout_o
```

to an LED, GPIO pin, or other logic.

### 5. Rebuild and Program FPGA

Compile the SoC and load the generated bitstream onto the VSDSquadron FPGA board.

---

## Documentation

Detailed documentation is available in the `docs/` directory.

| Document             | Description                               |
| -------------------- | ----------------------------------------- |
| IP_User_Guide.md     | IP overview, features, and architecture   |
| Register_Map.md      | Register definitions and software model   |
| Integration_Guide.md | SoC and board-level integration           |
| Example_Usage.md     | Example software, validation, and testing |

---

## How to Test

### Software Example

Use:

```text
software/timer_test.c
```

to test the Timer IP.

### One-Shot Mode

Expected behavior:

* Timer counts down once.
* STATUS.TIMEOUT becomes active.
* timeout_o is asserted.

### Periodic Mode

Expected behavior:

* Timer automatically reloads.
* Timeout events occur repeatedly.
* Connected LED blinks continuously.

---

## Validation

Verified through:

* RTL simulation
* Register read/write testing
* One-shot timer operation
* Periodic timer operation
* Hardware integration on VSDSquadron FPGA

---

## Known Limitations

* Single timer channel
* No interrupt support
* Polling-based operation
* No programmable prescaler
* Maximum count limited to 32 bits

---

## License

Developed as part of the VSDSquadron FPGA IP Development Program.
