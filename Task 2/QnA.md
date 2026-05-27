# Address used
~~~
Peripheral               Address
LEDs	                 0x00400000
UART DATA	             0x00400004
UART STATUS	             0x00400008
GPIO IP	                 0x0040000C
~~~

The GPIO peripheral uses:
localparam IO_GPIO_bit = 3;
for address decoding.

# How CPU accesses the IP
The CPU accesses the GPIO IP using standard memory-mapped read and write operations over the SoC memory bus.

## Write Operation
The CPU writes data using:
~~~
GPIO_REG = 0xDEADBEEF;
~~~
This generates:
~~~
* mem_addr
* mem_wdata
* mem_wmask
~~~
The GPIO IP detects:

IO access (isIO)
write strobe (mem_wstrb)
GPIO address decode (mem_wordaddr[IO_GPIO_bit]) and stores the value into the internal GPIO register.

## Read Operation

The CPU reads back the GPIO register using:
~~~
value = GPIO_REG;
~~~
The GPIO IP returns the stored register value through:
~~~
gpio_rdata
~~~
which is connected to the SoC read-data multiplexer and returned on:
~~~
mem_rdata
~~~

# What was validated in simulation
#### Simulation was performed using:
* Icarus Verilog (iverilog)
* GTKWave

#### The following functionality was verified:
* Correct GPIO register write operation
* Correct GPIO readback behavior
* Reset initialization behavior
* Consecutive register overwrites
* Invalid write protection
* Correct GPIO output updates
* Correct LED output mapping  

The simulation testbench executed multiple test cases with different 32-bit values and verified:
~~~
Results: 10 PASSED, 0 FAILED
~~~
