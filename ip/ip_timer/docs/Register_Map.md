# Timer IP Register Map

Base Address:

```text
0x20001000
```

## Register Summary

| Offset | Register | Access | Description      |
| ------ | -------- | ------ | ---------------- |
| 0x00   | CTRL     | R/W    | Control Register |
| 0x04   | LOAD     | R/W    | Load Value       |
| 0x08   | VALUE    | R      | Current Counter  |
| 0x0C   | STATUS   | R/W    | Timeout Status   |

---

## CTRL Register (0x00)

Reset Value:

```text
0x00000000
```

| Bit | Name   | Description            |
| --- | ------ | ---------------------- |
| 0   | ENABLE | Start timer            |
| 1   | MODE   | 0=One-shot, 1=Periodic |

### ENABLE

0 = Disabled

1 = Enabled

### MODE

0 = One-shot

1 = Periodic

---

## LOAD Register (0x04)

Reset Value:

```text
0x00000000
```

Stores the initial countdown value.

---

## VALUE Register (0x08)

Read-only.

Returns current timer count.

---

## STATUS Register (0x0C)

| Bit | Name    | Description   |
| --- | ------- | ------------- |
| 0   | TIMEOUT | Timer expired |

Write 1 to clear the flag.

