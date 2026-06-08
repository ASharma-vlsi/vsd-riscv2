# Example Usage

## 1. Overview

This document provides example software for using the Timer IP on the VSDSquadron RISC-V SoC.

The example demonstrates:

* Timer initialization
* One-shot operation
* Periodic operation
* Status polling
* Timeout detection

The software communicates with the Timer IP through memory-mapped registers.

---

# 2. Memory Map

Base Address:

```text id="kr8m0f"
0x20001000
```

Register Definitions:

```c id="0kz9k6"
#define TIMER_BASE   0x20001000

#define TIMER_CTRL   (*(volatile unsigned int *)(TIMER_BASE + 0x00))
#define TIMER_LOAD   (*(volatile unsigned int *)(TIMER_BASE + 0x04))
#define TIMER_VALUE  (*(volatile unsigned int *)(TIMER_BASE + 0x08))
#define TIMER_STAT   (*(volatile unsigned int *)(TIMER_BASE + 0x0C))
```

---

# 3. Example 1 – One-Shot Timer

## Description

The timer is loaded with a countdown value and started in one-shot mode.

When the timer reaches zero:

* STATUS.TIMEOUT becomes active.
* timeout_o is asserted.
* Timer stops automatically.

## Example Code

```c id="m95lnc"
#define TIMER_BASE   0x20001000

#define TIMER_CTRL   (*(volatile unsigned int *)(TIMER_BASE + 0x00))
#define TIMER_LOAD   (*(volatile unsigned int *)(TIMER_BASE + 0x04))
#define TIMER_VALUE  (*(volatile unsigned int *)(TIMER_BASE + 0x08))
#define TIMER_STAT   (*(volatile unsigned int *)(TIMER_BASE + 0x0C))

int main()
{
    TIMER_LOAD = 5000000;

    TIMER_CTRL = 0x1;

    while((TIMER_STAT & 0x1) == 0);

    TIMER_STAT = 1;

    while(1);

    return 0;
}
```

---

# 4. Example 2 – Periodic Timer

## Description

The timer automatically reloads after reaching zero and continues running.

This mode is useful for:

* LED blinking
* Heartbeat generation
* Periodic software tasks

## Example Code

```c id="4km4eh"
#define TIMER_BASE   0x20001000

#define TIMER_CTRL   (*(volatile unsigned int *)(TIMER_BASE + 0x00))
#define TIMER_LOAD   (*(volatile unsigned int *)(TIMER_BASE + 0x04))
#define TIMER_STAT   (*(volatile unsigned int *)(TIMER_BASE + 0x0C))

int main()
{
    TIMER_LOAD = 5000000;

    TIMER_CTRL = 0x3;

    while(1)
    {
        if(TIMER_STAT & 0x1)
        {
            TIMER_STAT = 1;
        }
    }

    return 0;
}
```

---

# 5. Software Execution Sequence

```text id="71f0eu"
Program LOAD Register
         |
         v
Configure CTRL Register
         |
         v
Enable Timer
         |
         v
Counter Starts
         |
         v
Counter Reaches Zero
         |
         v
STATUS.TIMEOUT = 1
         |
         v
Software Detects Event
         |
         v
Clear STATUS Flag
```

---

# 6. Validation

## Simulation Validation

The following tests were performed:

| Test                       | Result |
| -------------------------- | ------ |
| CTRL register write        | PASS   |
| LOAD register write        | PASS   |
| VALUE register read        | PASS   |
| STATUS register read/write | PASS   |
| One-shot mode operation    | PASS   |
| Periodic mode operation    | PASS   |
| Timeout flag generation    | PASS   |

---

## Hardware Validation

The Timer IP was integrated into the VSDSquadron FPGA SoC and accessed through software running on the RISC-V processor.

Validated functionality:

* Register read/write access
* Countdown operation
* Timeout flag generation
* Periodic reload operation
* Hardware timeout output

---

# 7. Expected Output

## One-Shot Mode

### Expected Behavior

1. Software loads timer value.
2. Timer starts counting down.
3. Timer reaches zero.
4. STATUS.TIMEOUT becomes '1'.
5. timeout_o becomes active.
6. Timer stops.

### User Observation

If timeout_o is connected to an LED:

```text id="l6qk3h"
LED turns ON once and remains ON.
```

---

## Periodic Mode

### Expected Behavior

1. Timer counts down.
2. Timer reaches zero.
3. Timeout flag is generated.
4. Timer reloads automatically.
5. Process repeats continuously.

### User Observation

If timeout_o is connected to an LED:

```text id="vw5wud"
LED blinks continuously at a rate determined by TIMER_LOAD.
```

---

## UART Output Example (Optional)

If UART debug messages are added:

```text id="sld9zm"
Timer Started
Timer Expired
Timer Reloaded
Timer Expired
Timer Reloaded
...
```

---

# 8. Video Demonstration Checklist

A successful hardware demonstration should show:

✔ FPGA programmed successfully

✔ Timer software executed

✔ Register access functioning

✔ One-shot timeout generated

✔ Periodic mode functioning

✔ LED response visible

✔ Timeout output verified

## One-Shot Mode
https://github.com/user-attachments/assets/cd6e4bef-0c97-4616-b766-a41b464fd0c1

## Periodic Mode
https://github.com/user-attachments/assets/3f491727-a978-40d8-9bb3-37031f554063

---

# 9. Common Failure Symptoms

| Symptom                     | Possible Cause              |
| --------------------------- | --------------------------- |
| Timer does not start        | ENABLE bit not set          |
| Timer never expires         | LOAD value is zero          |
| STATUS always reads zero    | Address decode issue        |
| Software hangs forever      | Polling wrong register      |
| LED never changes           | timeout_o not connected     |
| Register reads invalid data | Incorrect base address      |
| Timer inaccessible          | Peripheral not instantiated |

---

# 10. Known Limitations & Notes

The current Timer IP implementation has the following limitations:

### Functional Limitations

* Single timer channel
* No interrupt support
* Polling-based software model
* One timeout output only
* No capture/compare functionality

### Performance Limitations

* Countdown resolution depends on system clock frequency
* Maximum count limited to 32 bits

### Integration Notes

* Assumes stable system clock
* Requires valid memory-mapped address decoding
* Software must clear STATUS.TIMEOUT after detection

### Future Improvements

Possible future enhancements include:

* Interrupt generation
* Multiple timer channels
* Programmable prescaler
* PWM generation support
* Capture/compare functionality
* Multiple timeout outputs

---

# 11. Conclusion

The Timer IP provides a simple and reliable hardware timing solution for VSDSquadron FPGA designs. Through its memory-mapped interface, software can easily configure, start, monitor, and control timer operations for delay generation, periodic events, and general embedded timing applications.
