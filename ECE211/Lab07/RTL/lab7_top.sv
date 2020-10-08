`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2018 08:44:10 AM
// Design Name: 
// Module Name: lab7_top
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


module lab7_top(input logic clk100MHz, rst, input logic [3:0]  d4, d5, d6, d7,
                output logic [7:0] an_l, output logic [6:0] segs_l);
                
    logic sclk;
    
    clkdiv #(.DIVFREQ(1000)) divclock(.clk(clk100MHz), .reset(1'b0), .sclk);
    sevenseg_control seven_seg_control(.clk(sclk), .rst, .d0(4'b0010), .d1(4'b1111), .d2(4'b1010), .d3(4'b0001), .d4, .d5, .d6, .d7, .an_l, .segs_l);
                
endmodule
