`timescale 1ns / 1ps

module lab02_top #(BAUD_RATE=9600) (
    input logic clk, rst, single, continuous, [7:0] SW,
    output logic rdy_led, rdy_ext, txd_ext, txd
    );
    
    logic d_pulse, valid, rdy;
    assign valid = d_pulse | continuous;
    assign rdy_led = rdy;
    assign rdy_ext = rdy;
    assign txd_ext = txd;
    
    single_pulser U_PULSE(.clk, .din(single), .d_pulse);
    uart_xmit #(BAUD_RATE) U_XMIT (.clk100MHz(clk), .rst, .valid, .data(SW), .rdy, .txd);
    
endmodule
