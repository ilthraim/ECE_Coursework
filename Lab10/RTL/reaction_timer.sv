`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2018 08:02:27 AM
// Design Name: 
// Module Name: reaction_timer
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


module reaction_timer(
    input logic clk, start, enter, rst,
    output logic rgb_r, rgb_g, rgb_b, rs_en, [3:0] d3, d2, d1, d0);
    
    //logic start_deb, start;
    //logic enter_deb, enter;
    
    logic rwait_done, wait5_done, time_late, start_rwait, start_wait5, time_clr, time_en;
    logic [2:0] color_r, color_g, color_b;
    
    //debounce START_DEB(.clk, .pb(start_raw), .pb_debounced(start_deb));
    //debounce ENTER_DEB(.clk, .pb(enter_raw), .pb_debounced(enter_deb));
    
    //single_pulser START_SP(.clk, .din(start_deb), .d_pulse(start));
    //single_pulser ENTER_SP(.clk, .din(enter_deb), .d_pulse(enter));
    
    reaction_fsm FSM(.clk, .rst, .start, .enter, .rwait_done, .wait5_done, .time_late, .start_rwait, .start_wait5, .time_clr, .time_en, .rs_en, .color_r, .color_g, .color_b);
    random_wait RAND_WAIT(.clk, .rst, .start_rwait, .rwait_done);
    delay_counter5 DELAY_5(.clk, .rst, .start_wait5, .wait5_done);
    rgb_pwm RGB(.clk, .rst, .color_r, .color_g, .color_b, .rgb_r, .rgb_g, .rgb_b);
    time_count TIME_CNT(.clk, .rst, .time_clr, .time_en, .time_late, .d3, .d2, .d1, .d0);
    
    
    
endmodule
