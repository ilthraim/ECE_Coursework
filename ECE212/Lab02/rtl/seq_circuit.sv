`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 08:06:20 AM
// Design Name: 
// Module Name: seq_circuit
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


module seq_circuit(input logic clk, rst,
                    output logic sclk, lat, blank, [4:0] col, [2:0] row, abc);
                    
    logic col_done, sclk_done, sclk_enb, col_enb, abc_enb;
    
    fsm U_FSM(.clk, .rst, .col_done, .sclk_done, .sclk_enb, .col_enb, .abc_enb, .blank, .lat);
    abc_reg U_ABC(.clk, .rst, .enb(abc_enb), .q(abc));
    col_reg U_COL(.clk, .rst, .enb(col_enb), .done(col_done), .q(col));
    sclk_gen U_SCLK(.clk, .rst, .enb(sclk_enb), .sclk, .done(sclk_done));

    assign row = ((abc == 3'd7) ? 3'd0 : abc + 1);
    
                    
endmodule
