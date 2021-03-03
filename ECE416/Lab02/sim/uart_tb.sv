`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2021 01:35:16 PM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb();

    logic clk, rst, valid, rdy, txd;
    logic [7:0] data;
    
    uart_xmit #(100000000) DUV (.clk100MHz(clk), .rst, .valid, .data, .rdy, .txd);
    
    parameter CLK_PD = 10;
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    
    initial begin
        rst = 1;
        valid = 0;
        @(posedge clk) #1;
            rst = 0;
        @(posedge clk) #1;
            data = 8'b01010101;
            valid = 1;
        #(CLK_PD*11); #1;
            data = 8'b00110011;
        #(CLK_PD*11)
            data = 8'b00001111;
        #(CLK_PD*11)
                data = 8'b00000000;
        #(CLK_PD*11)
        $stop;
    end
endmodule
