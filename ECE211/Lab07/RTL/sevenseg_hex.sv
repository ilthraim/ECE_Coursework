`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2018 08:22:45 AM
// Design Name: 
// Module Name: sevenseg_hex
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


module sevenseg_hex(input logic [3:0] data, output logic [6:0] segs_l);
    logic [6:0] segs;

    always_comb
        begin
            case (data)
                4'd0: segs = 7'b1111110;
                4'd1: segs = 7'b0110000;
                4'd2: segs = 7'b1101101;
                4'd3: segs = 7'b1111001;
                4'd4: segs = 7'b0110011;
                4'd5: segs = 7'b1011011;
                4'd6: segs = 7'b1011111;
                4'd7: segs = 7'b1110000;
                4'd8: segs = 7'b1111111;
                4'd9: segs = 7'b1110011;
                4'd10: segs = 7'b1110111;
                4'd11: segs = 7'b0011111;
                4'd12: segs = 7'b0001101;
                4'd13: segs = 7'b0111101;
                4'd14: segs = 7'b1001111;
                4'd15: segs = 7'b1000111;
                default: segs = 7'b0000000;
            endcase
            
            segs_l = ~segs;
        end
endmodule
