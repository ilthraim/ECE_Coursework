//-----------------------------------------------------------------------------
// Module Name   : shreg
// Project       : Lab02 - Serial Data Transmitter
//-----------------------------------------------------------------------------
// Author        : Ethan Miller, John Burk  <millerek@lafayette.edu, burkj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : 10-bit shift register used to load start bit, 8 bits of data, and stop bit; 
// loads when ready and valid = 1 and stops shift after the final bit is transmitted (using count10 to count 10 increments). 
//-----------------------------------------------------------------------------
module shreg_xmit (
    input logic clk, rst, sh_idle, sh_ld, sh_en,
    input logic [7:0] data,
    output logic txd);

    logic [9:0] q;

    assign txd = q[0];

  always_ff @(posedge clk)
    if (rst) q <= '0;
    else if (sh_idle) q <= 'b1;
    else if (sh_ld) q <= {1'b1, data, 1'b0};

    else if (sh_en) begin
        q <= {1'b1, q[9:1]};
    end

endmodule: shreg_xmit