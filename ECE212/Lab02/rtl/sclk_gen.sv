`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 08:06:20 AM
// Design Name: 
// Module Name: sclk_gen
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


module sclk_gen(input logic clk, rst, enb,
                output logic sclk, done);
    
    localparam HALFPD = 5'd29;            
    
    logic [5:0] q;
    
                
    always_ff @(posedge clk)
        begin
            if (rst)
                begin
                    q <= 0;
                    sclk <= 0;
                end
            else if (enb)
                begin
                    if (q == HALFPD)
                        begin
                            sclk <= ~sclk;
                            q <= 0;
                        end
                    else
                        q <= q + 1;
                end
        end
        
    assign done = (q == HALFPD && sclk == 1);
                
endmodule
