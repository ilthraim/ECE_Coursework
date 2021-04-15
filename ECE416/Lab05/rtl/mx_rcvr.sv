
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2021 01:21:57 PM
// Design Name: 
// Module Name: mx_rcvr
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


module mx_rcvr #(parameter BIT_RATE=50000)(
    input logic clk, rst, rxd,
    output logic valid, cardet, error, [7:0] data);
    
    logic enb16, enb8, one_out, zero_out, h_out, l_out, SFD_out, pre_out, clr16, clr8, sh_ld, sh_in;
    
    mx_rcvr_fsm U_FSM (.clk, .rst, .enb16, .enb8, .one_out, .zero_out, .h_out, .l_out, .SFD_out, .pre_out, .valid, .cardet, .error, .clr16, .clr8, .sh_ld, .sh_in);
    rcv_shreg U_SHREG (.clk, .rst, .sh_ld, .sh_in, .data);
    rate_enb #(.RATE_HZ(BIT_RATE*16)) U_ENB16 (.clk, .rst, .clr(clr16), .enb_out(enb16));
    rate_enb #(.RATE_HZ(BIT_RATE*8)) U_ENB8 (.clk, .rst, .clr(clr8), .enb_out(enb8));
    correlator #(.LEN(16), .PATTERN(16'hffff), .HTHRESH(14), .LTHRESH(2)) U_END_CORR (.clk, .rst, .enb(enb16), .d_in(rxd), .h_out(one_out), .l_out(zero_out));
    correlator #(.LEN(16), .PATTERN(16'hff_00), .HTHRESH(14), .LTHRESH(2)) U_BIT_CORR (.clk, .rst, .enb(enb16), .d_in(rxd), .h_out, .l_out);
    correlator #(.LEN(64), .PATTERN(64'hf0_0f_f0_0f_f0_0f_f0_0f), .HTHRESH(54), .LTHRESH(10)) U_PRE_CORR (.clk, .rst, .enb(enb8), .d_in(rxd), .h_out(pre_out));
    correlator #(.LEN(64), .PATTERN(64'h0f_0f_0f_0f_f0_0f_f0_f0), .HTHRESH(54), .LTHRESH(10)) U_SFD_CORR (.clk, .rst, .enb(enb8), .d_in(rxd), .h_out(SFD_out));

    
endmodule
