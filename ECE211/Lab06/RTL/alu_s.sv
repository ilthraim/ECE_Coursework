`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2018 09:41:57 AM
// Design Name: 
// Module Name: alu_s
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


module alu_s #(parameter W=8) ( input logic [2:0] f,
                                input logic [W - 1:0] a, b,
                                output logic [W - 1:0] result,
                                output logic zero);
    logic [W - 1:0] BB;
    logic [W - 1:0] S;
    logic [W-1:0] d0, d1, d2, d3;
    logic Cout;
    
    mux4p #(W) MUX_1(.d0(d0), .d1(d1), .d2(d2), .d3(d3), .sel(f[1:0]), .y(result));
    
    assign BB = (f[2] ? ~b : b);
    assign {Cout, S} = a + BB + f[2];
    
    assign d0 = BB & a;
    assign d1 = BB | a;
    assign d2 = S;
    assign d3 = { {(W - 1){1'b0}}, S[W - 1]};
    assign zero = (result == '0);
    
    
    

endmodule
