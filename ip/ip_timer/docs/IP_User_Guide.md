# Timer IP User Guide

## Purpose

The Timer IP provides a programmable countdown timer for software-controlled timing operations inside the VSDSquadron SoC.

The timer can operate in:

* One-shot mode
* Periodic mode

## Typical Applications

* LED blinking
* Delay generation
* Periodic task scheduling
* Event timing
* Performance measurement

## Functional Description

Software loads a count value into the timer.

When enabled:

1. Counter begins decrementing.
2. Counter reaches zero.
3. Timeout flag is asserted.
4. Depending on mode:

   * One-shot → stops
   * Periodic → reloads automatically

## Block Diagram

```text
                CPU Bus
                   |
                   v
         +------------------+
         | Register Decode  |
         +------------------+
                   |
                   v
         +------------------+
         | Countdown Timer  |
         +------------------+
                   |
                   v
         +------------------+
         | Status / Output  |
         +------------------+
```

## Supported Modes

### One-Shot Mode

Counter runs once and stops at timeout.

### Periodic Mode

Counter automatically reloads and continues running.

