`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2018 08:02:27 AM
// Design Name: 
// Module Name: random_wait
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


module random_wait(
                input logic clk, rst, start_rwait,
                output logic rwait_done);
    
    logic [2:0] u_rand, s_rand;
    logic [3:0] a_rand, delay_count;
    logic [13:0] count1024;
    
    always_ff @(posedge clk)
        if (rst)
            u_rand <= 0;
        else
            begin
                u_rand <= u_rand + 1;
            
                if (start_rwait)
                    begin
                        s_rand <= u_rand;
                        count1024 <= 14'd0;
                    end
                else
                    count1024 <= count1024 + 1;
            end
        
    assign a_rand = {1'b0, s_rand} + 1;
    assign delay_count = count1024[13:10];
    assign rwait_done = (delay_count == a_rand);
        
endmodule
