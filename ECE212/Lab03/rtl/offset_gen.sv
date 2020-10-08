`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2019 08:06:49 AM
// Design Name: 
// Module Name: offset_gen
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


module offset_gen(input logic clk, rst, [4:0] col, [2:0] row,
                  output logic [12:0] RDADDR);
                  
    logic [23:0] count;
    logic [6:0] offset;
    logic [7:0] offset_col;
    
    always_ff @(posedge clk)
        begin
            if (rst)
                begin
                    count <= 0;
                    offset <= 0;
                end
            else
                begin
                    if (count == 24'd10000000) //100 ms
                        begin
                            count <= 0;
                            if (offset == 7'd99)
                                offset <= 0;
                            else
                                offset <= offset + 1;
                        end
                    else
                        count <= count + 1;
                end
        end
        
    always_comb
        begin
            offset_col = {3'b000, col} + offset;
            RDADDR = {offset_col, row};
        end
      
      
endmodule
