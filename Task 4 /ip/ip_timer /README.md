# Task-4: Timer IP Development

## Objective

Design, integrate, and validate a memory-mapped Timer IP for the RISC-V SoC.

---

## Timer IP Overview

The Timer IP provides a programmable countdown timer that generates a timeout event when the counter reaches zero.

Features:

* Memory-mapped register interface
* One-shot mode
* Periodic auto-reload mode
* Timeout status flag
* Software configurable load value
* Status flag clear using write-1-to-clear mechanism

---

## Register Map

| Offset | Register | R/W | Description           |
| ------ | -------- | --- | --------------------- |
| 0x00   | CTRL     | R/W | Control Register      |
| 0x04   | LOAD     | R/W | Timer Load Value      |
| 0x08   | VALUE    | R   | Current Counter Value |
| 0x0C   | STATUS   | R/W | Timeout Status        |

### CTRL Register

| Bit  | Name      | Description                |
| ---- | --------- | -------------------------- |
| 0    | EN        | Enable Timer               |
| 1    | MODE      | 0 = One-shot, 1 = Periodic |
| 2    | PRESC_EN  | Prescaler Enable           |
| 15:8 | PRESC_DIV | Prescaler Divide Value     |

### STATUS Register

| Bit | Name    | Description            |
| --- | ------- | ---------------------- |
| 0   | TIMEOUT | Set when timer expires |

Writing 1 to TIMEOUT clears the flag.

---

## Address Decoding

Timer IP is mapped into the SoC memory space using address decoding logic.

Address Range:

```
Offset   Name     R/W   Description
0x00     CTRL     R/W   Control Register
0x04     LOAD     R/W   Countdown Load Value
0x08     VALUE    R     Current Counter Value
0x0C     STATUS   R/W   Timeout Status Flag
```

### Address Offsets

```
Base Address : 0x20001000
Address Range: 0x20001000 - 0x2000100F
```

---

## RTL Implementation

Implemented in:

```text
rtl/timer_ip.v
```

### Functional Behavior

* LOAD register stores countdown value.
* VALUE register decrements when timer is enabled.
* STATUS.TIMEOUT is asserted when VALUE reaches zero.
* One-shot mode stops at timeout.
* Periodic mode reloads VALUE from LOAD and continues counting.
* STATUS.TIMEOUT is cleared by software.

---

## SoC Integration

### Integration Steps

* Added Timer IP instance inside SoC.
* Added address decode logic.
* Connected CPU read/write bus signals.
* Connected timer read data path to CPU.

### Integration Snippet

```verilog
// --------------------------------------------------
// Timer IP Address Decode
// Base Address : 0x20001000
// --------------------------------------------------

wire timer_sel;

assign timer_sel = mem_valid &&
                   (mem_addr[31:4] == 28'h2000100);

// --------------------------------------------------
// Timer IP Instance
// --------------------------------------------------

wire [31:0] timer_rdata;

timer_ip timer_inst (
    .clk    (clk),
    .resetn (resetn),

    .sel    (timer_sel),
    .wr_en  (mem_valid && mem_wstrb != 0),
    .rd_en  (mem_valid && mem_wstrb == 0),

    .addr   (mem_addr[3:2]),
    .wdata  (mem_wdata),
    .rdata  (timer_rdata)
);

```

---

## Simulation Validation

### Testbench

File:

```text
test/tb_timer_ip.v
```

Validated:

* LOAD register programming
* Timer enable operation
* STATUS.TIMEOUT generation
* STATUS.TIMEOUT clear
* One-shot mode
* Periodic mode

### Simulation Output

<img width="1857" height="953" alt="Screenshot from 2026-06-04 19-00-20" src="https://github.com/user-attachments/assets/c25b7ece-bdd5-4cdb-a0cf-58f4c24b1029" />
<img width="1857" height="1003" alt="Screenshot from 2026-06-04 19-00-33" src="https://github.com/user-attachments/assets/25a1fa69-2e57-40cf-954e-bb948d7a0c0f" />

### Waveform

<img width="1015" height="240" alt="Screenshot from 2026-06-04 19-05-04" src="https://github.com/user-attachments/assets/f4486285-b392-4463-b1a6-2ca3de86e4f8" />
<img width="1571" height="237" alt="Screenshot from 2026-06-04 19-05-26" src="https://github.com/user-attachments/assets/70c2d1d4-2ef4-4ef2-9122-148eb69528b9" />


---

## Software Validation

### Test Program

File:

```text
Firmware/timer_test.c
```

The software performs:

1. Program LOAD register
2. Enable timer
3. Poll STATUS.TIMEOUT
4. Clear STATUS.TIMEOUT
5. Demonstrate one-shot mode
6. Demonstrate periodic mode

### Waveform
#### TIMEOUT CLEAR MODE

TIMER_LOADED
<img width="1632" height="184" alt="image" src="https://github.com/user-attachments/assets/082a61aa-be29-4cc0-8278-5790d4a7579a" />

TIMER_Decrement
<img width="1635" height="182" alt="image" src="https://github.com/user-attachments/assets/19d8ca62-e9a0-41f3-bf98-e3d0d0d097dd" />

Timeout_RESET
<img width="1570" height="173" alt="image" src="https://github.com/user-attachments/assets/382457d8-c194-4b22-82b8-6ffa957a4c13" />

LED Blinks
<img width="1856" height="403" alt="Screenshot from 2026-06-04 18-00-45" src="https://github.com/user-attachments/assets/259c681c-93bc-45c8-94e5-856a494b3786" />


## Hardware Validation

Board Used:

```text
VSDSquadron FPGA
```

Validation Performed:

* Timer programmed through software
* Timeout detected
* LED toggled on timeout event

### Hardware Evidence

<img width="1160" height="868" alt="image" src="https://github.com/user-attachments/assets/cde8faf0-f4a5-4d5b-b19c-889bc20fe867" />

---

## Files Submitted

```text
ip/
└── timer_ip/
    ├── rtl/
    │   └── timer_ip.v
    ├── test/
    │   └── tb_timer_ip.v
    └── README.md
```

---

## Conclusion

Successfully designed and integrated a Timer IP into the RISC-V SoC.

Verified:

* Register functionality
* Memory-mapped access
* One-shot mode
* Periodic mode
* Software control through RISC-V processor
* FPGA hardware operation

