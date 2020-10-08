`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2018 08:03:54 AM
// Design Name: 
// Module Name: mux4p
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


module mux4p #(parameter W=8) ( input logic [W - 1:0] d0, d1, d2, d3,
                                input logic [1:0] sel,
                                output logic [W - 1:0] y);

    always_comb
    begin
        case(sel)
            2'b00 : y = d0;
            2'b01 : y = d1;
            2'b10 : y = d2;
            2'b11 : y = d3;
        endcase
    end

endmodule
