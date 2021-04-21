//-----------------------------------------------------------------------------
// Module Name   : mxtest_21_top
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : Ethan Miller, John Burk
// Created       : March 4 2021
//-----------------------------------------------------------------------------
// Description   : Top level testing module for the Manchester Transmitter.
//-----------------------------------------------------------------------------

module mxtest_21_top(
    input logic clk, rst, btnu, btnd,
    input logic [5:0] sw,
    output txd, txen, rdy, rdy_led
    );

    logic send, d_pulse;

    assign rdy_led = rdy;

    single_pulser U_SP (.clk, .din(btnu), .d_pulse);

    assign send = d_pulse || btnd;

    parameter BIT_RATE=10000;

    logic valid;
    logic [7:0] data;

    mxtest_21 U_MXTEST (.clk, .rst, .send, .rdy, .frame_len(sw), .data, .valid);

    manchester_xmit #(.BIT_RATE(BIT_RATE)) U_MX4 (
        .clk, .rst, .valid, .data, .rdy, .txen, .txd
        );

endmodule: mxtest_21_top