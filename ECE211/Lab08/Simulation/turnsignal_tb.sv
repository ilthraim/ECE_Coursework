`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2018 08:26:33 AM
// Design Name: 
// Module Name: turnsignal_tb
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


module turnsignal_tb;
   logic clk, rst, left, right, haz;
   logic l1, r1;

   turnsignal DUV( .left, .right, .haz, .rst, .clk, .l1, .r1 );

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
      repeat (4) @(posedge clk); #1;
      left = 0;
      repeat (2) @(posedge clk); #1;
      right = 1;
      repeat (2) @(posedge clk); #1;
      left = 1;
      repeat (2) @(posedge clk); #1;
      left = 0;
      right = 0;
      repeat (3) @(posedge clk); #1;
      haz = 1;
      @(posedge clk) #1;
      haz = 0;
      $stop;
   end

endmodule // count_tb;
