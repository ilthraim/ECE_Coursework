`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 08:37:30 AM
// Design Name: 
// Module Name: wait_timer
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


module wait_timer(input logic clk, rst, enb,
                  output logic done);
    logic [5:0] q;
    
    always_ff @(posedge clk)
        if (rst) q <= 0;
        else if (done) q <= 0;
        else if (enb) q <= q + 1;
        
    assign done = (q == 5'd29);
endmodule
