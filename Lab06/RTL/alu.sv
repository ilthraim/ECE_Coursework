`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2018 08:29:19 AM
// Design Name: 
// Module Name: alu
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


module alu #(parameter W=8) ( input logic [2:0] f,
                                input logic signed [W - 1:0] a, b,
                                output logic signed [W - 1:0] result,
                                output logic zero);

    always_comb
    begin
        case(f)
            3'b000 : result = a & b;
            3'b001 : result = a | b;
            3'b010 : result = a + b;
            3'b110 : result = a - b;
            3'b111 : if (a < b)
                        result = { {(W - 1){1'b0}}, 1'b1};
                    else result = '0;
            default : result = '0;
        endcase
    end
    
    assign zero = (result == '0);

endmodule
