`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2018 08:19:46 AM
// Design Name: 
// Module Name: pulse_monitor
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


module pulse_monitor(input logic clk, pulse_raw,
                    output logic [3:0] d0, d1, d2);
                    
    logic pulse_db, pulse_in, delay_done;
    logic [7:0] q_bpm;
    logic [7:0] q_tot;
    logic [7:0] q0, q1, q2, q3;
    
    debounce PULSE_DEB(.clk, .pb(pulse_raw), .pb_debounced(pulse_db));
    single_pulser PULSE_SP(.clk, .din(pulse_db), .d_pulse(pulse_in));
    
    delay_counter DELAY_CT(.clk, .delay_done);
    
    pulse_counter PULSE_CT(.clk, .enb(pulse_in), .clr(delay_done), .q(q0));
    
    pulse_reg REG_1(.clk, .lden(delay_done), .d(q0), .q(q1));
    pulse_reg REG_2(.clk, .lden(delay_done), .d(q1), .q(q2));
    pulse_reg REG_3(.clk, .lden(delay_done), .d(q2), .q(q3));
    
    convert_to_bpm BPM_CONV(.q1, .q2, .q3, .d(q_bpm));
    
    binary2bcd BIN_2_BCD(.b(q_bpm), .hundreds(d2), .tens(d1), .ones(d0));
                    
endmodule
