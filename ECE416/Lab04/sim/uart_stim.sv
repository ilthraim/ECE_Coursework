`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Module Name   : uart_stim
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : Ethan Miller & John Burk
// Created       : March 2021
//-----------------------------------------------------------------------------
// Description   : Stimulus-only TB for UART rxd
//-----------------------------------------------------------------------------


module uart_stim();

    logic clk, rst, rxd, rdy, valid, ferr, oerr;
    logic [7:0] data;
    
    uart_rxd #(.BAUD_RATE(9600)) DUV (.clk, .rst, .rxd, .rdy, .valid, .ferr, .oerr, .data);
    
    parameter CLK_PD = 10;
    parameter BIT_DELAY = 104167;
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    initial begin
        rst = 1;
        @(posedge clk) #1;
            rst = 0;
        @(posedge clk)
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b1;
        #BIT_DELAY;
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b1;
        #BIT_DELAY;
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b1;
        #BIT_DELAY;
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b1;
        #BIT_DELAY;
            rxd = 1'b1;
        #(BIT_DELAY*2)       
        $stop;
    end
endmodule

