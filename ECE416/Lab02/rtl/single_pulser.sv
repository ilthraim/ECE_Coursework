//-----------------------------------------------------------------------------
// Module Name   : single_pulser
// Project       : Lab02 - Serial Data Transmitter
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb. 2021
//-----------------------------------------------------------------------------
// Description   : Output a single pulse on when a rising edge is detected
// on the input din
//-----------------------------------------------------------------------------

module single_pulser(input logic clk, din, output logic d_pulse);
    logic dq1, dq2;

    always_ff @(posedge clk)
    begin
        dq1 <= din;
        dq2 <= dq1;
    end

    assign d_pulse = dq1 & ~dq2;
endmodule: single_pulser