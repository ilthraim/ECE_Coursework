`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2018 08:33:34 AM
// Design Name: 
// Module Name: pulse_reg
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


module pulse_reg(input logic clk, lden, [7:0] d,
                output logic [7:0] q);
                
    always_ff @(posedge clk)
        if (lden) q <= d;
                
endmodule
