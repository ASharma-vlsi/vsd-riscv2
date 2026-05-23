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

   
