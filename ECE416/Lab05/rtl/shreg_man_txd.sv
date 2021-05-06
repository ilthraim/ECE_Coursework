//-----------------------------------------------------------------------------
// Module Name   : shreg
// Project       : Lab02 - Serial Data Transmitter
//-----------------------------------------------------------------------------
// Author        : Ethan Miller, John Burk  <millerek@lafayette.edu, burkj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : 8-bit shift register used to load start bit, 8 bits of data, and stop bit;
// loads when ready and valid = 1 and stops shift after the final bit is transmitted
//-----------------------------------------------------------------------------
module shreg_man_txd (
    input logic clk, rst, sh_idle, sh_ld, sh_en,
    input logic [7:0] data,
    output logic txd);

    logic [7:0] q;

    assign txd = q[0];

  always_ff @(posedge clk)
    if (rst) q <= '0;
    else if (sh_idle) q <= 'b1;
    else if (sh_ld) q <= data;

    else if (sh_en) begin
        q <= {1'b1, q[7:1]};
    end

endmodule: shreg_man_txd