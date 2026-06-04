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

Base Address: `0x________________`

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

```text
Paste Address Mapping Here
```

### Address Offsets

```text
Paste Offset Decode Logic Here
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
Paste Timer Integration Code Here
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

```text
Paste Simulation Console Output Here
```

### Waveform

Insert waveform screenshot below:

![Waveform](images/timer_waveform.png)

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

### UART Output

```text
Paste UART Output Here
```

---

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

Insert board image/video screenshot below:

<img width="1160" height="868" alt="image" src="https://github.com/user-attachments/assets/8f78617c-7165-474a-be5e-05d9c4ff5ce9" />

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
