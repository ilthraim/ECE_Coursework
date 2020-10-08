`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2018 09:11:24 AM
// Design Name: 
// Module Name: lab8_top
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


module lab8_top(input logic clk100MHz, rst, left, right, haz,
                output logic [5:0] lout);
    logic clk;
        
    clkdiv CLK(.clk(clk100MHz), .reset(1'b0), .sclk(clk));
    tbird TBIRD(.clk, .rst, .left, .right, .haz, .lc(lout[0]), .lb(lout[1]), .la(lout[2]), .ra(lout[3]), .rb(lout[4]), .rc(lout[5]));
        
endmodule
