`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10/11/2018 08:36:17 AM
// Design Name:
// Module Name: sevenseg_control
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


module sevenseg_control(input logic clk, rst, rs_en, mode, input logic [3:0] rd0, rd1, rd2, rd3, pd0, pd1, pd2,
                        output logic [7:0] an_l, output logic [6:0] segs_l, output logic dp_l);

    logic [2:0] q;
    logic [3:0] y, NC;
    logic [15:0] rd, pd;
    logic [3:0] d0, d1, d2, d3;
    logic [6:0] segs_l_raw;

    assign rd = {rd0, rd1, rd2, rd3};
    assign pd = {pd0, pd1, pd2, 4'b0};
    assign dp_l = ~(mode & ~an_l[3] & rs_en);
    assign {d0, d1, d2, d3} = (mode ? rd : pd);

    count_3bit count_3(.clk, .rst, .q);
    dec_3_8 dec_3(.a(q), .y(an_l));
    mux_8_1 mux(.d0, .d1, .d2, .d3, .d4(NC), .d5(NC), .d6(NC), .d7(NC), .sel(q), .y);
    sevenseg_hex sevseg(.data(y), .rs_en, .mode, .segs_l(segs_l_raw));

    assign segs_l = (an_l[7] && an_l[6] && an_l[5] && an_l[4] && (an_l[3] || mode)) ? segs_l_raw : 8'b11111111;

endmodule
