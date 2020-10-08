`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 09:43:10 AM
// Design Name: 
// Module Name: top_tb
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


module top_tb;

    logic clk, rst;
    logic sclk, lat, blank, r1, g1, b1, r2, g2, b2;
    logic [2:0] abc;
    
    lab02_top DUV(.clk, .rst, .sclk, .lat, .blank, .r1, .g1, .b1, .r2, .g2, .b2, .abc );
    
    parameter CLK_PD = 10;
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    
    initial begin
        rst = 1;
        @(posedge clk); #1;
        rst = 0;
        @(posedge clk); #400000;
        $stop;
    end
    
endmodule
