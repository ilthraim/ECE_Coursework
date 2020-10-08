`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2018 08:57:44 AM
// Design Name: 
// Module Name: pulse_monitor_tb
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


module pulse_monitor_tb;

    logic clk, rst, pulse_raw, delay_done;
    logic [3:0] d0, d1, d2;
    logic [7:0] q0, q1, q2, q3;
    
    pulse_monitor DUV(.clk, .rst, .pulse_raw, .delay_done, .d0, .d1, .d2, .q0, .q1, .q2, .q3);
    
    parameter CLK_PD = 10;
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    
    always begin
        pulse_raw = 1'b0;
        repeat (500) @(posedge clk); #1;
        pulse_raw = 1'b1;
        repeat (500) @(posedge clk); #1;
    end
    
    initial begin
        rst = 1;
        @(posedge clk); #1;
        rst = 0;
        repeat (20000) @(posedge clk);
    end
    
endmodule
