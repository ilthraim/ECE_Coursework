`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2018 09:03:47 AM
// Design Name: 
// Module Name: en_ff
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


module en_ff(input logic clk, rst, en_p,
            output logic en);
            
    always_ff @(posedge clk)
        if (rst) en <= 0;
        else if (en_p) en <= ~en;
            
endmodule
