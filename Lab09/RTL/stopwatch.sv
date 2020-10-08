`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2018 08:43:14 AM
// Design Name: 
// Module Name: stopwatch
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


module stopwatch(input logic clk100MHz, en_in, lap_in, rst,
                    output logic [7:0] an_l, [6:0] segs_l, output logic dp);
                    
    logic clk, en_d, en_p, en, lap_d, lap;
    logic [3:0] d0, d1, d2, d3, d4, d5, d6, d7;
    
    clkdiv CLKDIV1(.clk(clk100MHz), .reset(1'b0), .sclk(clk));
    
    debounce EN_DEB(.clk, .pb(en_in), .pb_debounced(en_d));
    debounce LAP_DEB(.clk, .pb(lap_in), .pb_debounced(lap_d));
    
    single_pulser EN_SP(.clk, .din(en_d), .d_pulse(en_p));
    single_pulser LAP_SP(.clk, .din(lap_d), .d_pulse(lap));
    
    en_ff EN_FF(.clk, .rst, .en_p, .en);
    
    register_16 REG_16(.clk, .rst, .st(lap), .in({d3, d2, d1, d0}), .o({d7, d6, d5, d4}));
    
    bcd_control BCD_CTRL(.clk, .rst, .en, .d0, .d1, .d2, .d3);
    
    sevenseg_control SEVSEV_CTRL(.clk, .rst, .d0, .d1, .d2, .d3, .d4, .d5, .d6, .d7, .an_l, .segs_l, .dp);
                    
endmodule
