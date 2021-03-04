`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Module Name   : uart_tb
// Project       : Lab02 - Serial Data Transmitter
//-----------------------------------------------------------------------------
// Author        : Ethan Miller, John Burk  <millerek@lafayette.edu, burkj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : Testbench for lab 2 (stimulus-only)
//-----------------------------------------------------------------------------


module uart_tb();

    logic clk, rst, valid, rdy, txd;
    logic [7:0] data;
    
    uart_xmit #(100000000) DUV (.clk100MHz(clk), .rst, .valid, .data, .rdy, .txd);
    
    parameter CLK_PD = 10;
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    
    initial begin
        rst = 1;
        valid = 0;
        @(posedge clk) #1;
            rst = 0;
        @(posedge clk) #1;
            data = 8'b01010101;
            valid = 1;
        #(CLK_PD*11); #1;
            data = 8'b00110011;
        #(CLK_PD*11)
            data = 8'b00001111;
        #(CLK_PD*11)
                data = 8'b00000000;
        #(CLK_PD*11)
        $stop;
    end
endmodule
