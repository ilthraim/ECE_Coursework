//-----------------------------------------------------------------------------
// Module Name   : uart_rxd
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : Ethan Miller & John Burk
// Created       : March 2021
//-----------------------------------------------------------------------------
// Description   : Top-level that integrates the appropriate input and output
// logic as well as the integrated shift register, control FSM, counters, and rate enable modules.
//-----------------------------------------------------------------------------

module uart_rxd #(parameter BAUD_RATE=9600)(
    input logic clk, rst, rxd, rdy,
    output logic valid, xsnd, ferr, oerr, [7:0] data);

    localparam ENB_RATE = 16 * BAUD_RATE;

    logic clr, enb_out, clr10, enb10, cteq9, clr16, enb16, cteq7, cteq15, sh_ld;

    control_fsm U_FSM(.clk, .rst, .rxd, .enb_out, .cteq9, .cteq7, .cteq15, .rdy,
    .clr, .clr10, .enb10, .clr16, .enb16, .sh_ld, .valid, .ferr, .oerr);

    shreg_uart_rxd U_SHREG(.clk, .rst, .rxd, .sh_ld, .data);

    rate_enb #(.RATE_HZ(ENB_RATE)) U_RATE(.clk, .rst, .clr, .enb_out);

    count10_uart_rxd U_CT10(.clk, .rst, .enb(enb10), .clr(clr10), .cteq9);

    count16 U_CT16(.clk, .rst, .enb(enb16), .clr(clr16), .cteq15, .cteq7);
    
    assign xsnd = (valid && (data == 8'h04));

endmodule
