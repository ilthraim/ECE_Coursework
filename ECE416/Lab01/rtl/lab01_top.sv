`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Ethan Miller, John Burk
// 
// Create Date: 02/11/2021 02:30:13 PM
// Design Name: 
// Module Name: lab01_top
// Project Name: Lab 01
// Target Devices: Nexys A7
// Tool Versions: 
// Description: Top module of Lab 01 for ECE 416; implements temperature sensor, 
// seven segment display/decoder, and a binary2bcd module. Displays dashes on digits 7-5, black on digit 4, temp ints on 3-1, a decimal point, and a C for celsius.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lab01_top(
    input logic CLK100MHZ, rst,
    output logic [7:0] an_n,
    output logic [6:0] segs_n,
    output logic dp_n,
    inout TMP_SCL, // use inout only - no logic
    inout TMP_SDA // use inout only - no logic
    );
    logic tmp_rdy, tmp_err; // unused temp controller outputs
    // 13-bit two's complement result with 4-bit fractional part
    logic [12:0] temp;
    logic [3:0] hundreds, tens, ones;
    logic [6:0] d7, d6, d5, d4, d3, d2, d1, d0;
    
    assign d7 = 7'b0010000;
    assign d6 = 7'b0010000;
    assign d5 = 7'b0010000;
    
    assign d4 = 7'b1000000;
    
    assign d3 = {3'b000, hundreds};
    assign d2 = {3'b000, tens};
    assign d1 = {3'b010, ones};
    
    assign d0 = {3'b000, 4'hc};
    
    
    
    // instantiate the VHDL temperature sensor controller
    TempSensorCtl U_TSCTL (
        .TMP_SCL, .TMP_SDA, .TEMP_O(temp),
        .RDY_O(tmp_rdy), .ERR_O(tmp_err), .CLK_I(CLK100MHZ),
        .SRST_I(rst));
        
    binary2bcd U_BCD (.b(temp[11:4]), .hundreds, .tens, .ones);
    
    sevenseg_ctl U_CTRL (.clk(CLK100MHZ), .rst, .d7, .d6, .d5, .d4, .d3, .d2, .d1, .d0,
        .segs_n, .dp_n, .an_n);

endmodule
