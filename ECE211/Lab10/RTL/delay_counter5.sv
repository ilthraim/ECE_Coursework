`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2018 08:15:16 AM
// Design Name: 
// Module Name: delay_counter5
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


module delay_counter5(
    input logic clk, rst, start_wait5,
    output logic wait5_done);
    
    logic [12:0] count;
    logic en;
    
    always_ff @(posedge clk)
        if (rst)
            count = 13'd0;
        else
            begin
                if (start_wait5)
                    begin
                        en <= 1;
                        count <= 0;
                    end
                else if (en)
                    count <= count + 1;
                    
                if (count == 13'd5000)
                    begin
                        count <= 13'd0;
                        en <= 0;
                    end
            end
            
    assign wait5_done = (count == 13'd5000);
    
endmodule
