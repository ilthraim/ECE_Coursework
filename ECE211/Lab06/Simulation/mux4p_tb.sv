//-----------------------------------------------------------------------------
// Title         : dec_3_8_tb
// Project       : ECE 211 Digital Circuits 1
//-----------------------------------------------------------------------------
// File          : dec_3_8_tb.sv
// Author        : John Nestor
// Created       : 18.09.2018
// Last modified : 18.09.2018
//-----------------------------------------------------------------------------
// Description : Self-checking testbench based on a testvector file for
// 3-8 binary decoder dec_3_8.sv.  This file may be modified to craete
// testbenches for other modules.
//-----------------------------------------------------------------------------

module mux4p_tb();

    logic [3:0] d0, d1, d2, d3, y;
    logic [1:0] sel;
    mux4p #(.W(4)) DUV (.d0(d0), .d1(d1), .d2(d2), .d3(d3), .sel(sel), .y(y));
    
    initial
        begin
            sel = 2'd0; d0 = 4'd5;
            #10;
            sel = 2'd1; d1 = 4'd7;
            #10;
            sel = 2'd2; d2 = 4'd3;
            #10;
            sel = 2'd3; d3 = 4'd1;
            #10;
        end
   
endmodule