`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2018 09:05:01 AM
// Design Name: 
// Module Name: tbird_tb
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


module tbird_tb;

    logic clk, rst, left, right, haz, lc, lb, la, ra, rb, rc;
    
    tbird DUV(.clk, .rst, .left, .right, .haz, .lc, .lb, .la, .ra, .rb, .rc);
    
    parameter CLK_PD = 10;
       
       always begin
          clk = 1'b0; #(CLK_PD/2);
          clk = 1'b1; #(CLK_PD/2);
       end
       
       initial begin
          left = 0;
          right = 0;
          haz = 0;
          rst = 1;
          @(posedge clk) #1;
          rst = 0;
          repeat (2) @(posedge clk); #1;
          left = 1;
          repeat (6) @(posedge clk); #1;
          left = 0;
          repeat (2) @(posedge clk); #1;
          right = 1;
          repeat (6) @(posedge clk); #1;
          left = 1;
          repeat (6) @(posedge clk); #1;
          left = 0;
          right = 0;
          repeat (2) @(posedge clk); #1;
          haz = 1;
          repeat (6) @(posedge clk); #1;
          haz = 0;
          $stop;
       end

endmodule
