`timescale 1ns/1ps
`default_nettype none

`include "gpio_ctrl.v"

module tb_gpio;

    reg clk = 0;
    reg resetn = 0;

    always #5 clk = ~clk;

    reg  [29:0] mem_wordaddr;
    reg         isIO;
    reg         mem_wstrb;
    reg  [31:0] mem_wdata;

    wire [31:0] gpio_rdata;
    wire [31:0] gpio_out;

    gpio_ip DUT (
        .clk(clk),
        .resetn(resetn),

        .mem_wordaddr(mem_wordaddr),
        .isIO(isIO),
        .mem_wstrb(mem_wstrb),
        .mem_wdata(mem_wdata),

        .gpio_rdata(gpio_rdata),
        .gpio_out(gpio_out)
    );

    //--------------------------------------------------
    // Waveform
    //--------------------------------------------------

    initial begin
        $dumpfile("gpio_task3.vcd");
        $dumpvars(0,tb_gpio);
    end

    //--------------------------------------------------
    // Address Decode
    //--------------------------------------------------

    localparam GPIO_DATA_ADDR = 30'b000000000000000000000000001000;
    localparam GPIO_DIR_ADDR  = 30'b000000000000000000000000010000;
    localparam GPIO_READ_ADDR = 30'b000000000000000000000000100000;

    integer pass_count = 0;
    integer fail_count = 0;

    //--------------------------------------------------
    // WRITE TASK
    //--------------------------------------------------

    task write_reg;
        input [29:0] addr;
        input [31:0] data;
        begin
            @(negedge clk);

            mem_wordaddr = addr;
            mem_wdata    = data;
            isIO         = 1'b1;
            mem_wstrb    = 1'b1;

            @(posedge clk);
            #1;

            mem_wstrb = 0;
            isIO      = 0;
        end
    endtask

    //--------------------------------------------------
    // CHECK TASK
    //--------------------------------------------------

    task check_reg;
        input [29:0] addr;
        input [31:0] expected;
        input integer testnum;

        begin

            mem_wordaddr = addr;
            isIO         = 1'b1;
            mem_wstrb    = 1'b0;

            #1;

            $write(
                "Test %0d | Expected = 0x%08X | Read = 0x%08X | ",
                testnum,
                expected,
                gpio_rdata
            );

            if(gpio_rdata === expected)
            begin
                $display("PASS");
                pass_count = pass_count + 1;
            end
            else
            begin
                $display("FAIL");
                fail_count = fail_count + 1;
            end

            isIO = 0;

        end
    endtask

    //--------------------------------------------------
    // MAIN TEST
    //--------------------------------------------------

    initial begin

        mem_wordaddr = 0;
        mem_wdata    = 0;
        isIO         = 0;
        mem_wstrb    = 0;

        //----------------------------------------------
        // RESET
        //----------------------------------------------

        resetn = 0;

        repeat(4) @(posedge clk);

        resetn = 1;

        repeat(2) @(posedge clk);

        $display("");
        $display("=====================================");
        $display(" GPIO TASK-3 TEST START");
        $display("=====================================");

        //----------------------------------------------
        // TEST 1 : DATA RESET
        //----------------------------------------------

        check_reg(GPIO_DATA_ADDR,32'h00000000,1);

        //----------------------------------------------
        // TEST 2 : DIR RESET
        //----------------------------------------------

        check_reg(GPIO_DIR_ADDR,32'h00000000,2);

        //----------------------------------------------
        // TEST 3 : WRITE DATA
        //----------------------------------------------

        write_reg(GPIO_DATA_ADDR,32'hAAAAAAAA);

        check_reg(GPIO_DATA_ADDR,32'hAAAAAAAA,3);

        //----------------------------------------------
        // TEST 4 : WRITE DIR
        //----------------------------------------------

        write_reg(GPIO_DIR_ADDR,32'hFFFFFFFF);

        check_reg(GPIO_DIR_ADDR,32'hFFFFFFFF,4);

        //----------------------------------------------
        // TEST 5 : READ REGISTER
        //----------------------------------------------

        check_reg(GPIO_READ_ADDR,32'hAAAAAAAA,5);

        //----------------------------------------------
        // TEST 6 : CHANGE DATA
        //----------------------------------------------

        write_reg(GPIO_DATA_ADDR,32'h55555555);

        check_reg(GPIO_READ_ADDR,32'h55555555,6);

        //----------------------------------------------
        // TEST 7 : LED OUTPUT
        //----------------------------------------------

        $write(
            "Test 7 | gpio_out = 0x%08X | ",
            gpio_out
        );

        if(gpio_out === 32'h55555555)
        begin
            $display("PASS");
            pass_count = pass_count + 1;
        end
        else
        begin
            $display("FAIL");
            fail_count = fail_count + 1;
        end

        //----------------------------------------------
        // TEST 8 : Direction Masking
        //----------------------------------------------

        write_reg(GPIO_DIR_ADDR,32'h0000001F);

        write_reg(GPIO_DATA_ADDR,32'hFFFFFFFF);

        check_reg(GPIO_READ_ADDR,32'h0000001F,8);

        //----------------------------------------------
        // TEST 9 : Invalid Access
        //----------------------------------------------

        @(negedge clk);

        mem_wordaddr = GPIO_DATA_ADDR;
        mem_wdata    = 32'hDEADBEEF;
        mem_wstrb    = 1'b1;
        isIO         = 1'b0;

        @(posedge clk);
        #1;

        mem_wstrb = 0;

        check_reg(GPIO_DATA_ADDR,32'hFFFFFFFF,9);

        //----------------------------------------------
        // RESULTS
        //----------------------------------------------

        repeat(2) @(posedge clk);

        $display("");
        $display("=====================================");
        $display(" PASSED = %0d", pass_count);
        $display(" FAILED = %0d", fail_count);
        $display("=====================================");

        $finish;

    end

    //--------------------------------------------------
    // TIMEOUT
    //--------------------------------------------------

    initial begin

        #10000;

        $display("TIMEOUT");

        $finish;

    end

endmodule
