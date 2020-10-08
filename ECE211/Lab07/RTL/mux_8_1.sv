`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2018 08:30:07 AM
// Design Name: 
// Module Name: 8_1_mux
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


module mux_8_1(input logic [3:0] d0, d1, d2, d3, d4, d5, d6, d7, input logic [2:0] sel,
                output logic [3:0] y);
                
    always_comb
    begin
        case(sel)
            3'b000 : y = d0;
            3'b001 : y = d1;
            3'b010 : y = d2;
            3'b011 : y = d3;
            3'b100 : y = d4;
            3'b101 : y = d5;
            3'b110 : y = d6;
            3'b111 : y = d7;
            default : y = '0;
        endcase
    end
endmodule
