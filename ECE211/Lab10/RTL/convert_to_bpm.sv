`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2018 08:36:05 AM
// Design Name: 
// Module Name: convert_to_bpm
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


module convert_to_bpm(input logic [7:0] q1, q2, q3,
                    output logic [7:0] d);
                   
    logic [7:0] qtot;
             
    assign qtot = (q1 + q2) + q3;
                    
    assign d = qtot << 2;
                    
endmodule
