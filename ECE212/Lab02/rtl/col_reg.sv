`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 08:06:20 AM
// Design Name: 
// Module Name: col_reg
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


module col_reg(input logic clk, rst, enb, 
                output logic done, [4:0] q);
            
    always_ff @(posedge clk)
        begin
            if (rst)
                q <= 0;
            else if (enb)
                if (q == 5'd31)
                    q <= 0;
                else
                    q <= q + 1;
        end
    
    assign done = (q == 5'd31 && enb);
                
endmodule
