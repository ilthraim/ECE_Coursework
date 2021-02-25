`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Ethan Miller, John Burk
// 
// Create Date: 02/11/2021 01:40:43 PM
// Design Name: 
// Module Name: sevenseg_ext_top
// Project Name: Lab 01
// Target Devices: Nexys A7
// Tool Versions: 
// Description: Top level unit test for the sevenseg controller. Uses switches 6-0 to configure display in accordance with requirements
// outlined on the lab document. See the master constraints file to enable switches.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sevenseg_ext_top(input logic [6:0] SW, output logic DP, [6:0] segs_n, [7:0] an_n);

    sevenseg_ext U0(.d(SW), .segs_n, .dp_n(DP));
    assign an_n = 8'b11111110;

endmodule
