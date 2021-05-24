//-----------------------------------------------------------------------------
// Module Name   : fsafe
// Project       : wimpFi
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : May 2021
//-----------------------------------------------------------------------------
// Description   : Asserts a txen_fail signal when txen is high for too long
//
//-----------------------------------------------------------------------------
module fsafe(
    input clk, rst, txen,
    output txen_safe, txen_fail
    );
    parameter BPLIMIT = 512;
    parameter BIT_RATE = 50000;

    logic bp_enb;

    rate_enb #(.RATE_HZ(BIT_RATE)) U_RATENB (
        .clk, .rst, .enb_out(bp_enb)
    );

    fsafe_fsm #(.BPLIMIT(BPLIMIT)) U_FLOGIC (
        .clk, .rst, .txen, .bp_enb, .txen_fail
    );

    assign txen_safe = txen && (!txen_fail);

endmodule: fsafe
