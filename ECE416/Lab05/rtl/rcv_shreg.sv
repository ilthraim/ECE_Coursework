//-----------------------------------------------------------------------------
// Module Name   : rcv_shreg
// Project       : Manchester Receiver
//-----------------------------------------------------------------------------
// Author        : Ethan Miller & John Burk
// Created       : April 2021
//-----------------------------------------------------------------------------
// Description   : Shift register to load data to receiver
//-----------------------------------------------------------------------------
module rcv_shreg(
    input logic clk, rst, sh_ld, sh_in,
    output logic [7:0] data);
    
    always_ff @(posedge clk) begin
        if (rst)
            data <= 0;
        else begin
            if (sh_ld)
                data <= {sh_in, data[7:1]};
        end
    end
    
endmodule
