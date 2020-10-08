`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2018 08:19:58 AM
// Design Name: 
// Module Name: count3bit
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


module count_3bit( input logic clk, rst,
                    output logic [2:0] q);
                    
    always_ff @(posedge clk)
         if (rst) q <= 3'd0;
         else q <= q + 3'd1;
                    
endmodule
