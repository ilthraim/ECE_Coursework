
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/18/2021 01:25:23 PM
// Design Name:
// Module Name: shreg
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


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
