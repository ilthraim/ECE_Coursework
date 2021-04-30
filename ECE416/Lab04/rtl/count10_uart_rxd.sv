
//-----------------------------------------------------------------------------
// Module Name   : counter
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Basic binary counter with enable & sync. reset
//-----------------------------------------------------------------------------

module  count10 (
    input logic clk, rst, enb, clr,
    output logic cteq9
    );

    logic [3:0] q;

    assign cteq9 = (q == 4'd8);

    always_ff @(posedge clk)
        if (rst || clr)      q <= '0;
        else if (enb) q <= q + 1;

endmodule: count10
