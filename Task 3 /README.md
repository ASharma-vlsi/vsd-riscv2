# Task-3: Design a Multi-Register GPIO IP with Software Control

## Objective:-

Upgrade the simple GPIO IP from Task-2 into a realistic multi-register peripheral that supports direction control, data output, and readback functionality. Integrate it into the existing RISC-V SoC and validate the design using simulation and software running on the processor.

## Step 1: Study and Plan

### Register Map Design

The GPIO IP was extended to support three memory-mapped registers:

| Offset | Register  | Description               |
| ------ | --------- | ------------------------- |
| 0x00   | GPIO_DATA | GPIO output data register |
| 0x04   | GPIO_DIR  | GPIO direction register   |
| 0x08   | GPIO_READ | GPIO readback register    |

### Address Decoding

The GPIO registers are selected using one-hot decoding on the memory word address:

```verilog
wire sel_data = mem_wordaddr[3];
wire sel_dir  = mem_wordaddr[4];
wire sel_read = mem_wordaddr[5];
```

This allows software to independently access each register.

---

## Step 2: Implement Multi-Register RTL

### Internal Registers

The GPIO IP contains:

```verilog
reg [31:0] gpio_data;
reg [31:0] gpio_dir;
```

### GPIO_DATA Register

```verilog
gpio_data <= mem_wdata;
```

Stores the output values written by software.

### GPIO_DIR Register

```verilog
gpio_dir <= mem_wdata;
```

Controls GPIO direction:

* 1 → Output
* 0 → Input

### GPIO_READ Register

```verilog
assign gpio_read = gpio_data & gpio_dir;
```

Returns the current GPIO state.

---

## Step 3: Integrate the IP into the SoC

### Include GPIO Controller

```verilog
`include "gpio_ctrl.v"
```

added alongside:

```verilog
`include "clockworks.v"
`include "emitter_uart.v"
```

### GPIO Instance

The GPIO Control IP is instantiated inside the SOC module and connected to the memory bus signals.

```verilog
gpio_ip GPIO (
    .clk(clk),
    .resetn(resetn),
    .mem_wordaddr(mem_wordaddr),
    .isIO(isIO),
    .mem_wstrb(mem_wstrb),
    .mem_wdata(mem_wdata),
    .gpio_rdata(gpio_rdata),
    .gpio_out(gpio_out)
);
```

### GPIO Address Detection

```verilog
wire isGPIO =
       mem_wordaddr[3] |
       mem_wordaddr[4] |
       mem_wordaddr[5];
```

This allows access to all GPIO registers.

### LED Connection

```verilog
always @(posedge clk)
begin
    LEDS <= gpio_out[4:0];
end
```

The first five GPIO outputs are connected to the onboard LEDs.

---

## Step 4: Software Validation

### Firmware

A C program was written to:

* Configure GPIO direction
* Write GPIO output values
* Read GPIO state
* Print results through UART

Example:

```c
GPIO_DIR = 0x1F;

GPIO_DATA = 0x15;

value = GPIO_READ;

print_hex(value);
```

### Expected UART Output

```text
READ = 0x00000015
READ = 0x0000000A
READ = 0x00000015
```

This verifies that:

* Direction register works correctly
* Output register updates GPIO outputs
* Readback register returns expected values

---

## Step 5: Validate using Simulation

The GPIO IP was verified using a dedicated testbench.

The testbench validates:

* Reset behavior
* GPIO_DATA write/read
* GPIO_DIR write/read
* GPIO_READ functionality
* Multiple register updates
* Address decoding correctness

### Simulation Results

GTKWave screenshot:

<img width="1859" height="1052" alt="Screenshot from 2026-05-31 23-45-53" src="https://github.com/user-attachments/assets/bc8ae18c-6c9b-4a70-ab8e-dfdc24c35c4a" />

Testbench output screenshot:

<img width="1859" height="1052" alt="Screenshot from 2026-05-31 23-46-09" src="https://github.com/user-attachments/assets/a8c2c24f-2c0c-466e-bedd-c559c926db93" />

---

## Step 6: Hardware Validation (Optional)

The updated bitstream was programmed onto the VSDSquadron FPGA board.

GPIO outputs were connected to the onboard LEDs.

Observed behavior:

* GPIO_DIR controls output enable
* GPIO_DATA controls LED states
* GPIO_READ returns the current output values

Board photo:

<img width="1600" height="1197" alt="image" src="https://github.com/user-attachments/assets/d2f7b770-ca90-4bf5-aa44-88f5d047e2cf" />

---

## Conclusion

Successfully designed and integrated a multi-register GPIO Control IP into the RISC-V SoC. The peripheral supports direction control, output data storage, and readback functionality through memory-mapped registers. Validation through simulation and software confirmed correct operation of the complete software-to-hardware control path.
