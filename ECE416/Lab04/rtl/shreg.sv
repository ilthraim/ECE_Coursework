//-----------------------------------------------------------------------------
// Module Name   : shreg
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : Ethan Miller & John Burk
// Created       : March 2021
//-----------------------------------------------------------------------------
// Description   : Shift register used for loading data + start and stop bits
//-----------------------------------------------------------------------------


module shreg(input logic clk, rst, rxd, sh_ld, output logic [7:0] data);

    logic [9:0] datar;

    assign data = datar[8:1];

    always_ff @(posedge clk) begin
        if (rst)
            datar <= 0;
        else if (sh_ld)
            datar <= {rxd, datar[9:1]};
    end

endmodule
