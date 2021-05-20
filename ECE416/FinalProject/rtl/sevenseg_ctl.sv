`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Ethan Miller, John Burk
// 
// Create Date: 02/11/2021 02:21:43 PM
// Design Name: 
// Module Name: sevenseg_ctl
// Project Name: Lab 01
// Target Devices: Nexys A7
// Tool Versions: 
// Description: Implements the extended seven segment display using time-multiplexing; rapidly toggles each individual digit
// with segment data for each. High refresh rate creates a solid image with no flicker.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sevenseg_ctl(
 input logic clk, rst,
 input logic [6:0] d7, d6, d5, d4, d3, d2, d1, d0,
 output logic [6:0] segs_n,
 output logic dp_n,
 output logic [7:0] an_n
);

    logic [6:0] d_in;
    logic[7:0] an;
    logic [2:0] sel;
    logic clr, enb_out;

    sevenseg_ext U_SEG(.d(d_in), .segs_n, .dp_n);
    
    rate_enb #(.RATE_HZ(1000)) U_ENB(.clk, .rst, .clr, .enb_out);
    
    counter U_CNT(.clk, .rst, .enb(enb_out), .q(sel));
    
    mux8 U_MUX(.d0, .d1, .d2, .d3, .d4, .d5, .d6, .d7, .sel, .y(d_in));
    
    dec_3_8 U_DEC(.a(sel), .y(an));
    
    assign an_n = ~an;

endmodule
