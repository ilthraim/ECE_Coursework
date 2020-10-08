`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 09:20:40 AM
// Design Name: 
// Module Name: lab02_top
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


module lab02_top(input logic clk, rst,
                output logic sclk, lat, blank, r1, g1, b1, r2, g2, b2, [2:0] abc);
                
    logic [4:0] col;
    logic [2:0] row;
    
    seq_circuit U_SEQ(.clk, .rst, .sclk, .lat, .blank, .col, .row, .abc);
    pixel_gen U_PIXEL(.col, .row, .r1, .g1, .b1, .r2,. g2, .b2);
    
    
    
endmodule
