`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2018 08:54:27 AM
// Design Name: 
// Module Name: bcd_control
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


module bcd_control(input logic clk, rst, en,
                    output logic [3:0] d0, d1, d2, d3);
                    
    logic c0, c1, c2;
    logic [3:0] nc0;
    logic nc1;
                    
    counter_bcd THOUSANDTHS(.clk, .rst, .enb(en), .q(d0), .carry(c0));
    counter_bcd HUNDREDTHS(.clk, .rst, .enb(c0), .q(d1), .carry(c1));
    counter_bcd TENTHS(.clk, .rst, .enb(c1), .q(d2), .carry(c2));
    counter_bcd ONES(.clk, .rst, .enb(c2), .q(d3), .carry(ncl));
    
endmodule
