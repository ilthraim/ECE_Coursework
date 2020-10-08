`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2019 08:30:20 AM
// Design Name: 
// Module Name: lab_1_control
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


module lab_1_control(input logic clk, rst, raw_in,
                    output logic [15:0] led);
                    
    wire raw_deb, in, enb_out;
    localparam DISPLAY_RATE = 5;
                    
    debounce U_DEB (.clk, .pb(raw_in), .rst, .pb_debounced(raw_deb));
    single_pulser U_SP(.clk, .din(raw_deb), .d_pulse(in));
    delay_enb #(.DELAY_MS(1000/DISPLAY_RATE)) U_DELAY_ENB(.clk, .rst, .clr(1'b0), .enb_out);
    lab_1_fsm U_FSM(.clk, .rst, .enb(enb_out), .in, .leds(led));
    
endmodule
