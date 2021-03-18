`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2021 03:15:32 PM
// Design Name: 
// Module Name: uart_stim
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


module uart_stim();

    logic clk, rst, rxd, rdy, valid, ferr, oerr;
    logic [7:0] data;
    
    uart_rxd #(.BAUD_RATE(9600)) DUV (.clk, .rst, .rxd, .rdy, .valid, .ferr, .oerr, .data);
    
    parameter CLK_PD = 10;
    parameter BIT_DELAY = 104167;
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    initial begin
        rst = 1;
        @(posedge clk) #1;
            rst = 0;
        @(posedge clk)
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b1;
        #BIT_DELAY;
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b1;
        #BIT_DELAY;
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b1;
        #BIT_DELAY;
            rxd = 1'b0;
        #BIT_DELAY;
            rxd = 1'b1;
        #BIT_DELAY;
            rxd = 1'b1;
        #(BIT_DELAY*2)       
        $stop;
    end
endmodule

