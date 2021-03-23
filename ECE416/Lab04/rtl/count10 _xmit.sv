//-----------------------------------------------------------------------------
// Module Name   : count10
// Project       : Lab02 - Serial Data Transmitter
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Co-author     : Modified by Ethan Miller and John Burk
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Basic binary counter with enable & sync. reset; modified for
// 10 count to determine when to stop shift register.
//-----------------------------------------------------------------------------

module  count10_xmit #(parameter W=4) (
    input logic clk, rst, clr, enb,
    output logic ct_eql9
    );

    logic [W-1:0] q;

    always_ff @(posedge clk)
        if (rst || clr)      q <= '0;
        else if (enb) q <= q + 1;
        
    assign ct_eql9 = q==4'd9;

endmodule: count10_xmit