`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2018 08:29:07 AM
// Design Name: 
// Module Name: delay_counter
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


module delay_counter(input logic clk,
                    output logic delay_done);
        
    logic [12:0] count;
                    
    always_ff @(posedge clk)
        if (delay_done) count <= 0;
        else count <= count + 13'd1;
       
     assign delay_done = (count == 13'd5000);
                    
endmodule
