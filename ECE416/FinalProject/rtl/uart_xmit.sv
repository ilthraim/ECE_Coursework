//-----------------------------------------------------------------------------
// Module Name   : uart_xmit
// Project       : Lab02 - Serial Data Transmitter
//-----------------------------------------------------------------------------
// Author        : Ethan Miller, John Burk  <millerek@lafayette.edu, burkj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : Top-level for UART transmitter. Implements the FSM, shift register, counter, and rate enable modules
//-----------------------------------------------------------------------------

module uart_xmit #(BAUD_RATE=9600) (
    input logic clk100MHz, rst, valid, [7:0] data, 
    output logic rdy, txd 
);

    logic br_en, br_st, ct_en, ct_eql9, sh_idle, sh_ld, sh_en, ct_clr;

    rate_enb #(BAUD_RATE) U_ENB (.clk(clk100MHz), .rst, .clr(br_st), .enb_out(br_en));
    count10 #(4) U_COUNT(.clk(clk100MHz), .rst, .clr(ct_clr), .enb(ct_en), .ct_eql9);
    shreg_uart_xmit U_SHREG(.clk(clk100MHz), .rst, .sh_idle, .sh_ld, .sh_en, .data, .txd);
    xmit_fsm U_FSM(.clk(clk100MHz), .rst, .valid, .br_en, .ct_eql9, .rdy, .sh_ld, .sh_idle, .sh_en, .br_st, .ct_clr, .ct_en);

endmodule