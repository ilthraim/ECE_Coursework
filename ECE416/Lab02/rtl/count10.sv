//-----------------------------------------------------------------------------
// Module Name   : counter
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Basic binary counter with enable & sync. reset
//-----------------------------------------------------------------------------

module  count10 #(parameter W=4) (
    input logic clk, rst, clr, enb,
    output logic ct_eql9
    );

    logic [W-1:0] q;

    always_ff @(posedge clk)
        if (rst || clr)      q <= '0;
        else if (enb) q <= q + 1;
        
    assign ct_eql9 = q==4'd9;

endmodule: count10