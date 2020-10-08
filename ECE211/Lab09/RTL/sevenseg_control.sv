`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2018 08:36:17 AM
// Design Name: 
// Module Name: sevenseg_control
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


module sevenseg_control(input logic clk, rst, input logic [3:0] d0, d1, d2, d3, d4, d5, d6, d7,
                        output logic [7:0] an_l, output logic [6:0] segs_l, output logic dp);
                        
    logic [2:0] q;
    logic [3:0] y;
    
    count_3bit count_3(.clk, .rst, .q);
    dec_3_8 dec_3(.a(q), .y(an_l));
    mux_8_1 mux(.d0, .d1, .d2, .d3, .d4, .d5, .d6, .d7, .sel(q), .y);
    sevenseg_hex sevseg(.data(y), .segs_l);
    
    assign dp = (an_l[2] && an_l[6]);

    
endmodule
