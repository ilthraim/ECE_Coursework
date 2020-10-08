`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2019 07:55:27 PM
// Design Name: 
// Module Name: lab3_tb
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


module lab3_tb;

    logic clk, rst;
    logic nextpb, sclk, lat, blank, r1, g1, b1, r2, g2, b2;
    logic [2:0] nextcolor, disp_row;
    
    lab3_top DUV(.clk, .rst, .nextpb, .nextcolor, .sclk, .lat, .blank, .r1, .g1, .b1, .r2, .g2, .b2, .disp_row);
    
    parameter CLK_PD = 10;
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    
    initial begin
        rst = 1;
        nextpb = 0;
        nextcolor = 0;
        @(posedge clk); #1;
        rst = 0;
        @(posedge clk); #400000;
        $stop;
    end
    
endmodule

