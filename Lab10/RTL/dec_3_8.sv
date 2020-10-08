`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2018 08:03:42 AM
// Design Name: 
// Module Name: dec_3_8
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


module dec_3_8(input logic [2:0] a, output logic [7:0] y);

    logic [7:0] yl;
    always_comb
        begin
        case (a)
            3'd0: yl = 8'b00000001;
            3'd1: yl = 8'b00000010;
            3'd2: yl = 8'b00000100;
            3'd3: yl = 8'b00001000;
            3'd4: yl = 8'b00010000;
            3'd5: yl = 8'b00100000;
            3'd6: yl = 8'b01000000;
            3'd7: yl = 8'b10000000;
            default: yl = 4'b0000;
        endcase
        y = ~yl;
        end
endmodule
