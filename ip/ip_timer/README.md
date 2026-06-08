# Timer IP for VSDSquadron FPGA

## Overview

The Timer IP is a memory-mapped programmable countdown timer designed for integration into the VSDSquadron RISC-V SoC.

It provides software-controlled timing functionality suitable for:

* Delay generation
* Periodic events
* LED blinking
* Time measurement
* Software polling applications

## Features

* 32-bit countdown timer
* One-shot mode
* Periodic mode
* Memory-mapped register interface
* Status flag generation
* Simple SoC integration
* Compatible with VSDSquadron FPGA platform

## Directory Structure

```text
rtl/
software/
docs/
README.md
```

## Quick Integration

1. Add `timer_ip.v` to the RTL project.
2. Instantiate the Timer IP inside the SoC.
3. Allocate address space at:

```c
0x20001000
```

4. Connect the timeout output to LEDs or logic.
5. Rebuild FPGA image.

## Documentation

* docs/IP_User_Guide.md
* docs/Register_Map.md
* docs/Integration_Guide.md
* docs/Example_Usage.md

## Validation

Run:

```c
timer_test.c
```

Expected result:

* One-shot mode:

  * Timer expires once.
  * LED changes state once.

* Periodic mode:

  * LED continuously blinks.

## Known Limitations

* Single timer channel
* No interrupt support
* Polling-based operation
* Assumes system clock frequency is known

