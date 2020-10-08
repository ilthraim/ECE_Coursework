`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2019 08:06:49 AM
// Design Name: 
// Module Name: pixel_gen
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


module pixel_gen(input logic clk, rst, nextpb, [2:0] nextcolor, [4:0] col, [2:0] row, 
                 output logic r1, g1, b1, r2, g2, b2);
     
     logic [3:0] WE;
     logic [9:0] WRADDR;
     logic [31:0] DI;
     logic [12:0] RDADDR;
     logic [3:0] DOB, DOT;
     
     num_decoder NUM_DEC(.clk, .rst, .nextpb, .nextcolor, .WE, .WRADDR, .DI);
     offset_gen O_GEN(.clk, .rst, .col, .row, .RDADDR);
     fb_bram_bottom BOT_RAM(.WRCLK(clk), .RDCLK(clk), .RST(rst), .DI, .WRADDR, .WE, .RDADDR, .DO(DOB));
     fb_bram_top TOP_RAM(.WRCLK(clk), .RDCLK(clk), .RST(rst), .RDADDR, .DO(DOT)); 
     
     assign {r1, g1, b1} = DOT[2:0];
     assign {r2, g2, b2} = DOB[2:0];
     
endmodule
