`timescale 1ns / 1ps

module tb_timer_ip;

    // ----------------------------------
    // Clock / Reset
    // ----------------------------------
    reg clk;
    reg resetn;

    initial begin
    $dumpfile("timer_ip.vcd");
    $dumpvars(0, tb_timer_ip);
    end
    
    initial clk = 0;
    always #5 clk = ~clk;   // 100 MHz clock

    // ----------------------------------
    // Bus signals
    // ----------------------------------
    reg        sel;
    reg        wr_en;
    reg        rd_en;
    reg [1:0]  addr;
    reg [31:0] wdata;
    wire [31:0] rdata;

    integer timeout_count;

    // ----------------------------------
    // DUT
    // ----------------------------------
    timer_ip DUT (
        .clk   (clk),
        .resetn(resetn),
        .sel   (sel),
        .wr_en (wr_en),
        .rd_en (rd_en),
        .addr  (addr),
        .wdata (wdata),
        .rdata (rdata)
    );

    // ----------------------------------
    // Write Task
    // ----------------------------------
    task write_reg(input [1:0] a, input [31:0] d);
    begin
        @(posedge clk);
        sel   <= 1;
        wr_en <= 1;
        rd_en <= 0;
        addr  <= a;
        wdata <= d;

        @(posedge clk);
        sel   <= 0;
        wr_en <= 0;
    end
    endtask

    // ----------------------------------
    // Read Task
    // ----------------------------------
    task read_reg(input [1:0] a);
    begin
        @(posedge clk);
        sel   <= 1;
        wr_en <= 0;
        rd_en <= 1;
        addr  <= a;

        @(posedge clk);
        sel   <= 0;
        rd_en <= 0;
    end
    endtask

    // ----------------------------------
    // Test Sequence
    // ----------------------------------
    initial begin

        // Default values
        sel   = 0;
        wr_en = 0;
        rd_en = 0;
        addr  = 0;
        wdata = 0;
        timeout_count = 0;

        // Reset
        resetn = 0;
        repeat (3) @(posedge clk);
        resetn = 1;

        // ==================================================
        // TEST 1 : ONE-SHOT MODE
        // ==================================================
        $display("\n====================================");
        $display("      ONE-SHOT TIMER TEST");
        $display("====================================");

        write_reg(2'b01, 32'd10);      // LOAD = 10
        write_reg(2'b00, 32'b0001);    // ENABLE=1, PERIODIC=0

        repeat (15) @(posedge clk);

        read_reg(2'b11);               // STATUS
        $display("STATUS after timeout = %h (expect 1)", rdata);

        // Clear timeout flag
        write_reg(2'b11, 32'h1);

        read_reg(2'b11);
        $display("STATUS after clear   = %h (expect 0)", rdata);

        // ==================================================
        // TEST 2 : PERIODIC MODE
        // ==================================================
        $display("\n====================================");
        $display("      PERIODIC TIMER TEST");
        $display("====================================");

        write_reg(2'b01, 32'd10);      // LOAD = 10
        write_reg(2'b00, 32'b0011);    // ENABLE=1, PERIODIC=1

        timeout_count = 0;

        repeat (50) begin

            @(posedge clk);

            // Read VALUE register
            read_reg(2'b10);
            $display("VALUE = %0d", rdata);

            // Read STATUS register
            read_reg(2'b11);

            if (rdata[0]) begin
                timeout_count = timeout_count + 1;

                $display("Periodic timeout #%0d detected",
                         timeout_count);

                // Clear timeout flag
                write_reg(2'b11, 32'h1);
            end
        end

        $display("------------------------------------");
        $display("Total periodic timeouts = %0d",
                 timeout_count);
        $display("------------------------------------");

        if (timeout_count >= 2)
            $display("PASS: Periodic mode verified.");
        else
            $display("FAIL: Periodic mode not verified.");

        $display("\n====================================");
        $display("          TEST COMPLETE");
        $display("====================================");

        $finish;
    end

endmodule
