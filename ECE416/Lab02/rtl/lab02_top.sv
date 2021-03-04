//-----------------------------------------------------------------------------
// Module Name   : lab02_top
// Project       : Lab02 - Serial Data Transmitter
//-----------------------------------------------------------------------------
// Author        : Ethan Miller, John Burk  <millerek@lafayette.edu, burkj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : Top level for lab 2.
// Description   : Implements the pulser and uart_xmit modules, interfaces with the USB-UART bridge, 
// accepts data inputs as well as single and continuous transmission triggers. 
// The single pulser is OR'd with the continuous signal since either can assert the valid bit. 
// Data is passed using switches. LED0/rdy_led signifies that rdy signal is working in hardware, 
// while JA[1] and [2] are used to view rdy and txd waveforms on an oscilloscope. 
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

module lab02_top #(BAUD_RATE=9600) (
    input logic clk, rst, single, continuous, [7:0] SW,
    output logic rdy_led, rdy_ext, txd_ext, txd
    );
    
    logic d_pulse, valid, rdy;
    assign valid = d_pulse | continuous;
    assign rdy_led = rdy;
    assign rdy_ext = rdy;
    assign txd_ext = txd;
    
    single_pulser U_PULSE(.clk, .din(single), .d_pulse);
    uart_xmit #(BAUD_RATE) U_XMIT (.clk100MHz(clk), .rst, .valid, .data(SW), .rdy, .txd);
    
endmodule
