`timescale 1ns/1ps
`default_nettype none

`define BENCH

`include "riscv.v"

module tb_soc;

    reg RESET = 0;

    wire [4:0] LEDS;
    wire TXD;

    //////////////////////////////////////////////////////
    // DUT
    //////////////////////////////////////////////////////

    SOC DUT (
        .RESET(RESET),
        .LEDS(LEDS),
        .RXD(1'b1),
        .TXD(TXD)
    );

    //////////////////////////////////////////////////////
    // RESET SEQUENCE
    //////////////////////////////////////////////////////

    initial begin

        $dumpfile("soc_wave.vcd");
        $dumpvars(0, tb_soc);

        RESET = 1;

        #100;

        RESET = 0;

    end

    //////////////////////////////////////////////////////
    // TIMEOUT
    //////////////////////////////////////////////////////

    initial begin

        #5000000;

        $display("TIMEOUT");

        $finish;

    end

endmodule
