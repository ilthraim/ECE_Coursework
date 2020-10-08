`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2018 09:08:35 AM
// Design Name: 
// Module Name: register_16
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


module register_16(input logic clk, rst, st, [15:0] in,
                    output logic [15:0] o);

    always_ff @(posedge clk)
        if (rst) o <= 16'd0;
        else if (st) o <= in;
        
                    
endmodule
