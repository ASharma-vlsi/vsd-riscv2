# Task-1: Environment Setup & RISC-V Reference Bring-Up

## Objective
Set up the development environment and successfully run a working RISC-V reference design, followed by running the VSDFPGA labs on the same environment.

## Step 1: Set up GitHub Codespace 
#### Build Environment
* **Platform:** GitHub Codespace
* **Reference repository:** `vsd-riscv2`
* **Lab repository:** `vsdfpga_labs`

#### Work Completed
1. Forked the `vsd-riscv2` repository in my account.
2. Launched GitHub Codespace from the fork.
3. Ensured that the Codespace builds successfully and opens without errors.
<img width="1899" height="907" alt="image" src="https://github.com/user-attachments/assets/5830be11-8f2d-4f58-b44b-a37ef0dd3c07" />

## Step 2: Verify RISC-V Reference Flow
## Reference RISC-V Program
#### Step 1. Open the Repository
Go to:
https://github.com/vsdip/vsd-riscv2
#### Step 2. Create a Codespace
1. Log in with your GitHub account.
2. Click the green Code button.
3. Select Open with Codespaces → New codespace.
4. Wait while the environment builds. (First time may take 10–15 minutes.)
<img width="1919" height="910" alt="image" src="https://github.com/user-attachments/assets/3db6e903-ad60-4484-9553-282719ad9d28" />

#### Step 3. Verify the Setup
In the terminal that opens, type:
```
riscv64-unknown-elf-gcc --version
spike --version
iverilog -V
```
You should see version information for each tool.
<img width="1919" height="909" alt="image" src="https://github.com/user-attachments/assets/57fcfbf0-1001-4688-a620-1b95450d8883" />

#### Step 4. Run Your First Program
   1. Go to the `samples` folder.
   2. Compile the program:
      ```
      riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
      ```
   3. Run it with Spike:
      ```
      spike pk sum1ton.o
      ```
Expected outcome:
```
Sum from 1 to 9 is 45
```
<img width="1919" height="911" alt="image" src="https://github.com/user-attachments/assets/842f1304-aea8-47a5-8773-fc988d42b25e" />

#### Step 5. Next Steps
* You can edit and run your own C programs.
<img width="1919" height="912" alt="image" src="https://github.com/user-attachments/assets/57900eb7-aaef-47a6-be0a-4f82103826e3" />

## Step 3: Clone and Run VSDFPGA Labs
Once the RISC-V reference flow works, clone the FPGA labs repository inside the same Codespace:

#### Setup
1. Clone the repository:
   ```
   cd ~
   git clone https://github.com/vsdip/vsdfpga_labs
   ```
<img width="1919" height="911" alt="image" src="https://github.com/user-attachments/assets/bf080dfb-ddf2-41db-a4cb-f7d6a6be2c10" />

#### Building & Flashing
1. Review the RISC-V logo code (do not modify):
   ```
   cd ~/vsdfpga_labs/basicRISCV/Firmware
   nano riscv_logo.c  # Review and close (Ctrl+X)
   make riscv_logo.bram.hex
   ```
   You should see the below messages
   <img width="1919" height="912" alt="image" src="https://github.com/user-attachments/assets/03feee2a-7891-486c-a141-7afa468226e5" />

2. Build the firmware and FPGA bitstream:
   ```
   cd ~/vsdfpga_labs/basicRISCV/RTL
   make clean
   make build
   ```
   
3. Flash to FPGA:
   ```
   sudo make flash
   ```

## Step 4: Local Machine Preparation
1. Clone both repositories locally:
   ```
   vsd-riscv2
   vsdfpga_labs
   ```
# Understanding Check
1. Where is the RISC-V program located in the vsd-riscv2 repository?
   
   The RISC-V programs in the vsd-riscv2 repository are located inside the samples/ directory. The main contents of this directory are:
   * samples/1ton_custom.c 
   * samples/Makefile 
   * samples/load.S 
   * samples/sum1ton.c

2. How is the program compiled and loaded into memory?

   The program is compiled using the RISC-V cross-compiler toolchain (`riscv64-unknown-elf-gcc`).  
   Inside the `samples/` directory, the `Makefile` is used for compilation.      
   Example compilation command:
   ```
   riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
   ```
   For the `sum1ton` program, the C source file (`sum1ton.c`) is compiled along with the assembly startup file (`load.S`) to generate an ELF binary.  
   This ELF file contains the machine code and memory sections such as `.text`, `.data`, and `.bss`.
   After compilation, the ELF binary is loaded into the simulated memory of the RISC-V system in the Codespace/simulation environment.  
   A simulator like Spike or the testbench reads the ELF file and maps it into the processor address space.  
   The program is then placed into the instruction memory starting from the reset vector, allowing the RISC-V core to fetch and execute the instructions.

3. How does the RISC-V core access memory and memory-mapped IO?

   The RISC-V core accesses memory and memory-mapped IO through the internal bus and address decoding logic.
   The instruction memory, data memory, and peripherals are all mapped into a common address space.  
   The processor uses standard load and store instructions to communicate with both memory and IO devices.

   - Instruction fetches are done from instruction memory.
   - Data accesses are performed using load (`lw`, `lb`) and store (`sw`, `sb`) instructions.

   When the core generates an address, the address decoder inside the SoC checks the address range:

   - If the address belongs to RAM or ROM, the access is directed to memory.
   - If the address belongs to a peripheral region, the access is redirected to memory-mapped IO devices such as GPIO, UART, LEDs, or timers.

   In the VSD Squadron SoC simulation environment, the ELF program is loaded into memory, and the RISC-V core starts execution from the reset vector.  
   During execution, any read/write operation to a peripheral address directly controls the corresponding hardware module through memory-mapped registers.

   This approach allows the processor to access hardware peripherals in the same way as normal memory, simplifying the overall SoC design.

4. Where would a new FPGA IP block logically integrate in this system?

   A new FPGA IP block like GPIO, Timer, SPI, or UART would be integrated into the VSD Squadron RISC-V SoC mainly at three levels.

   First, at the RTL level, a new Verilog module is created for the IP block along with its memory-mapped registers for read/write operations.

   Then at the SoC top-level, the IP block is connected to the main CPU bus by connecting signals like address, data, read enable, and write enable.  
   The address decoder is also updated to assign a specific base address to the new IP block so that whenever the CPU accesses that address range, the request  gets routed to the peripheral.

   At the software level, the C firmware running on the RISC-V core accesses the IP using memory-mapped IO by reading from or writing to the assigned base address.

   So overall, the main integration point for a new FPGA IP block is the SoC top-level bus interconnect and address decoder, which connects the CPU with the peripheral modules.

## Conclusion: 
The GitHub Codespace environment was successfully set up using the `vsd-riscv2` repository. Also, the reference programs were executed successfully.
