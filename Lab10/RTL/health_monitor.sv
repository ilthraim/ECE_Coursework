`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2018 08:52:49 AM
// Design Name: 
// Module Name: health_monitor
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


module health_monitor(input logic clk100Mhz, rst, start, enter, pulse_in, mode,
                    output logic led_r, led_g, led_b, dp_l, [7:0] an_l, [6:0] segs_l);
                    
    logic clk, rs_en;
    logic [3:0] rd3, rd2, rd1, rd0, pd2, pd1, pd0;
    
                    
    clkdiv CLKDIV(.clk(clk100Mhz), .reset(rst), .sclk(clk));
    reaction_timer R_TIMER(.clk, .start(start), .enter(enter), .rst, .rgb_r(led_r), .rgb_g(led_g), .rgb_b(led_b), .rs_en, .d3(rd3), .d2(rd2), .d1(rd1), .d0(rd0));
    pulse_monitor P_MONITOR(.clk, .pulse_raw(pulse_in), .d0(pd0), .d1(pd1), .d2(pd2));
    sevenseg_control SEV_SEG(.clk, .rst, .rs_en, .mode, .rd0, .rd1, .rd2, .rd3, .pd0, .pd1, .pd2, .an_l, .segs_l, .dp_l);
                    
endmodule
