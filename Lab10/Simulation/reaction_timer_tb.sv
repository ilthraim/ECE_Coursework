`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 09:02:15 AM
// Design Name: 
// Module Name: reaction_timer_tb
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


module reaction_timer_tb;
    
    logic clk, start, enter, rst;
    logic rgb_r, rgb_g, rgb_b, rs_en;
    logic [3:0] d3, d2, d1, d0;
    
    reaction_timer DUV(.clk, .start, .enter, .rst, .rgb_r, .rgb_g, .rgb_b, .rs_en, .d3, .d2, .d1, .d0);
    
    parameter CLK_PD = 10;
    
    always begin
            clk = 1'b0; #(CLK_PD/2);
            clk = 1'b1; #(CLK_PD/2);
    end
    
    initial begin
        rst = 1;
        @(posedge clk); #1;
        rst = 0;
        start = 1;
        @(posedge clk); #1;
        start = 0;
    end

endmodule
