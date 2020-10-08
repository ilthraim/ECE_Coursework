`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2019 08:06:49 AM
// Design Name: 
// Module Name: lab3_top
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


module lab3_top(input logic clk, rst, nextpb, [2:0] nextcolor,
                output logic sclk, lat, blank, r1, g1, b1, r2, g2, b2, [2:0] disp_row);
        
    logic [4:0] col;
    logic [2:0] row;
    logic nextpb_deb;
    logic nextpb_in;
                
    seq_circuit U_SEQ(.clk, .rst, .sclk, .lat, .blank, .col, .row, .abc(disp_row));
    pixel_gen U_PIXEL(.clk, .rst, .nextpb(nextpb_in), .nextcolor, .col, .row, .r1, .g1, .b1, .r2, .g2, .b2);
    debounce U_DEB(.clk, .pb(nextpb), .rst, .pb_debounced(nextpb_deb));
    single_pulser U_SP(.clk, .din(nextpb_deb), .d_pulse(nextpb_in));
                
endmodule
