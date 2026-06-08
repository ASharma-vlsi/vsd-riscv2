# Example Usage

## One-Shot Timer Example

```c
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
}
```

## Periodic Timer Example

```c
#define TIMER_BASE   0x20001000

#define TIMER_CTRL   (*(volatile unsigned int *)(TIMER_BASE + 0x00))
#define TIMER_LOAD   (*(volatile unsigned int *)(TIMER_BASE + 0x04))

int main()
{
    TIMER_LOAD = 5000000;

    TIMER_CTRL = 0x3;

    while(1);
}
```

## Expected Behavior

### One-Shot

* Timer counts down once.
* Timeout flag becomes active.
* Software detects completion.

### Periodic

* Timer repeatedly reloads.
* Timeout events occur continuously.

## Validation Performed

Simulation:

* Register read/write verified
* One-shot operation verified
* Periodic operation verified
* Timeout flag verified

Hardware:

* Timer integrated into VSDSquadron SoC
* Timer accessible through memory-mapped interface
* LED blinking demonstrated using periodic mode

## Common Issues

### Timer does not start

Check ENABLE bit.

### Timer never expires

Verify LOAD register is non-zero.

### Software cannot access timer

Verify address decoding logic.

### LED does not blink

Verify timeout signal connection.

