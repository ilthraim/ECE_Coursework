`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2018 08:58:29 AM
// Design Name: 
// Module Name: lab4_top_level
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


module lab4_top_level(input logic [2:0] a, input logic [3:0] data,
                      output logic [7:0] y, output logic [6:0] segs_l);
                      
      dec_3_8 DEC_0(.a(a), .y(y));
      sevenseg_hex SEVEN_0(.data(data), .segs_l(segs_l));
                      
endmodule
