
//-----------------------------------------------------------------------------
// Module Name   : counter
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Basic binary counter with enable & sync. reset
//-----------------------------------------------------------------------------

module count16 (
    input logic clk, rst, enb, clr,
    output logic cteq15, cteq7
    );

    logic [3:0] q;

    assign cteq15 = (q == 4'd15);
    assign cteq7 = (q == 4'd7);

    always_ff @(posedge clk)
        if (rst || clr)      q <= '0;
        else if (enb) q <= q + 1;

endmodule: count16
