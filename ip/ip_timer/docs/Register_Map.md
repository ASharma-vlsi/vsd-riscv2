# Register Map

## Base Address

```text
0x20001000
```

The Timer IP occupies 16 bytes of address space.

Address Range:

```text
0x20001000 – 0x2000100F
```

---

# 1. Register Summary

| Offset | Register | Access | Description             |
| ------ | -------- | ------ | ----------------------- |
| 0x00   | CTRL     | R/W    | Timer control register  |
| 0x04   | LOAD     | R/W    | Initial countdown value |
| 0x08   | VALUE    | R      | Current counter value   |
| 0x0C   | STATUS   | R/W    | Timer timeout status    |

---

# 2. CTRL Register

Offset:

```text
0x00
```

Access:

```text
Read / Write
```

Reset Value:

```text
0x00000000
```

## Bit Definitions

| Bit  | Name     | Reset | Description          |
| ---- | -------- | ----- | -------------------- |
| 0    | ENABLE   | 0     | Enable timer         |
| 1    | MODE     | 0     | Timer operating mode |
| 31:2 | Reserved | 0     | Reserved             |

### ENABLE Bit

| Value | Meaning        |
| ----- | -------------- |
| 0     | Timer disabled |
| 1     | Timer enabled  |

### MODE Bit

| Value | Meaning       |
| ----- | ------------- |
| 0     | One-shot mode |
| 1     | Periodic mode |

## Read Behavior

Returns current configuration.

## Write Behavior

Updates timer enable and operating mode.

---

# 3. LOAD Register

Offset:

```text
0x04
```

Access:

```text
Read / Write
```

Reset Value:

```text
0x00000000
```

## Bit Definitions

| Bits | Name       | Reset | Description             |
| ---- | ---------- | ----- | ----------------------- |
| 31:0 | LOAD_VALUE | 0     | Initial countdown value |

## Read Behavior

Returns programmed load value.

## Write Behavior

Loads the countdown start value.

---

# 4. VALUE Register

Offset:

```text
0x08
```

Access:

```text
Read Only
```

Reset Value:

```text
0x00000000
```

## Bit Definitions

| Bits | Name        | Reset | Description         |
| ---- | ----------- | ----- | ------------------- |
| 31:0 | COUNT_VALUE | 0     | Current timer count |

## Read Behavior

Returns the current counter value.

## Write Behavior

Writes ignored.

---

# 5. STATUS Register

Offset:

```text
0x0C
```

Access:

```text
Read / Write
```

Reset Value:

```text
0x00000000
```

## Bit Definitions

| Bit  | Name     | Reset | Description           |
| ---- | -------- | ----- | --------------------- |
| 0    | TIMEOUT  | 0     | Timer expiration flag |
| 31:1 | Reserved | 0     | Reserved              |

### TIMEOUT Bit

| Value | Meaning       |
| ----- | ------------- |
| 0     | Timer active  |
| 1     | Timer expired |

## Read Behavior

Returns timeout status.

## Write Behavior

Writing '1' clears the timeout flag.

---

# 6. Software Programming Model

## Overview

The Timer IP is controlled through memory-mapped registers. Software programs the countdown value, selects the operating mode, enables the timer, and monitors completion through the STATUS register.

---

## Typical Initialization Sequence

### Step 1: Program Countdown Value

Write the desired countdown value to the LOAD register.

```c
TIMER_LOAD = 5000000;
```

### Step 2: Configure Timer Mode

Configure CTRL register.

One-Shot Mode:

```c
TIMER_CTRL = 0x1;
```

Periodic Mode:

```c
TIMER_CTRL = 0x3;
```

### Step 3: Enable Timer

Setting ENABLE = 1 starts the countdown operation.

### Step 4: Monitor Completion

Software checks STATUS.TIMEOUT.

```c
while((TIMER_STAT & 0x1) == 0);
```

### Step 5: Clear Timeout Flag

```c
TIMER_STAT = 1;
```

---

## Polling Method

The current Timer IP uses polling.

Example:

```c
while((TIMER_STAT & 0x1) == 0)
{
    // Wait for timer expiration
}
```

Advantages:

* Simple implementation
* No interrupt controller required

Limitations:

* CPU continuously checks status
* Less efficient than interrupt-driven operation

---

## Typical Software Flow

```text
Write LOAD Register
        |
        v
Configure CTRL Register
        |
        v
Enable Timer
        |
        v
Timer Counts Down
        |
        v
STATUS.TIMEOUT = 1
        |
        v
Software Detects Expiration
        |
        v
Clear STATUS Flag
```

---

## Recommended Usage

### One-Shot Mode

Use for:

* Fixed delays
* Timeout detection
* Single-event scheduling

### Periodic Mode

Use for:

* LED blinking
* Repetitive tasks
* Software heartbeat generation
* Periodic polling operations

```
```
