# Timer IP Integration Guide

## RTL Files Required

```text
rtl/timer_ip.v
```

## Address Allocation

Reserve:

```text
0x20001000 - 0x2000100F
```

Address map:

```text
0x20001000 CTRL
0x20001004 LOAD
0x20001008 VALUE
0x2000100C STATUS
```

## SoC Integration

Instantiate:

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

## Address Decode Example

```verilog
wire timer_sel =
    (mem_addr[31:4] == 28'h2000100);
```

## CPU Access

Software accesses registers using memory-mapped I/O.

Reads:

```c
value = TIMER_VALUE;
```

Writes:

```c
TIMER_LOAD = 1000000;
```

## Output Connections

The timeout signal may be connected to:

* User LEDs
* GPIO outputs
* Future interrupt controller

Example:

```verilog
assign LEDS[0] = timeout_o;
```

