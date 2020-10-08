`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2018 08:02:27 AM
// Design Name: 
// Module Name: rgb_pwm
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


module rgb_pwm(
                input logic clk, rst,
                input logic [2:0] color_r, color_g, color_b,
                output logic rgb_r, rgb_g, rgb_b);
                
    logic [3:0] count;
    
    always_ff @(posedge clk)
        if (rst)
            count <= 4'd0;
        else
            count <= count + 1;
        
    assign rgb_r = ({1'b0, color_r} > count);
    assign rgb_g = ({1'b0, color_g} > count);
    assign rgb_b = ({1'b0, color_b} > count);
    
endmodule
