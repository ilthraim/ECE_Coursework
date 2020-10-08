`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 08:16:55 AM
// Design Name: 
// Module Name: pixel_gen
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


module pixel_gen(input logic [4:0] col, [2:0] row,
                output logic r1, b1, g1, r2, b2, g2);
                
    always_comb
        case(col)
            5'd31: {r1, g1, b1, r2, g2, b2} = 6'b001001;
            5'd30: {r1, g1, b1, r2, g2, b2} = 6'b010010;
            5'd29: {r1, g1, b1, r2, g2, b2} = 6'b011011;
            5'd28: {r1, g1, b1, r2, g2, b2} = 6'b100100;
            5'd27: {r1, g1, b1, r2, g2, b2} = 6'b101101;
            5'd26: {r1, g1, b1, r2, g2, b2} = 6'b110110;
            5'd25: {r1, g1, b1, r2, g2, b2} = 6'b111111;
            5'd24: {r1, g1, b1, r2, g2, b2} = 6'b000000;
            default: {r1, g1, b1, r2, g2, b2} = 6'b000000;
        endcase
                
endmodule
