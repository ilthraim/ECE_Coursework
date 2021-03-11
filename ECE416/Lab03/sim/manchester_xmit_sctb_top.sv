`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2021 12:26:41 AM
// Design Name: 
// Module Name: manchester_xmit_sctb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module manchester_xmit_sctb_top();
timeunit 1ns / 100ps;  // define timing for this module and all submodules
    parameter TRANSMITS = 2;
    parameter CLKPD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 50000000;
    parameter IDLE_BITS = 2;
    logic clk, rst, valid, txd, rdy, txen;
    
    logic [7:0] data;

    clk_gen #(.CLKPD(CLKPD)) CG (.clk);

    manchester_xmit #(.BIT_RATE(BAUD_RATE),.IDLE_BITS(IDLE_BITS)) DUV (.clk, .rst, .valid, .data, .rdy, .txd, .txen);

    manchester_xmit_sctb #(.BAUD_RATE(BAUD_RATE),.CLOCK_PD(CLKPD),.IDLE_BITS(IDLE_BITS)) TB (.clk, .rst, .valid, .data, .txd, .rdy, .txen);
endmodule
