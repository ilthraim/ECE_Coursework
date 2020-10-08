`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2018 08:02:27 AM
// Design Name: 
// Module Name: time_count
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


module time_count(
    input logic clk, rst, time_clr, time_en,
    output logic time_late, [3:0] d3, d2, d1, d0);
    
    logic [13:0] count;
    
    bcd_control BCD(.clk, .rst(rst || time_clr), .en(time_en), .d0, .d1, .d2, .d3);
    
    always_ff @(posedge clk)
        if (rst || time_clr)
            begin
                count <= 0;
            end
        else if (time_en)
            count <= count + 1;
            
    assign time_late = (count == 14'd9999);
    
    
    
endmodule
