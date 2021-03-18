
module uart_rxd #(parameter BAUD_RATE=9600)(
    input logic clk, rst, rxd, rdy,
    output logic valid, ferr, oerr, [7:0] data);

    localparam ENB_RATE = 16 * BAUD_RATE;

    logic clr, enb_out, clr10, enb10, cteq9, clr16, enb16, cteq7, cteq15, sh_ld;

    control_fsm U_FSM(.clk, .rst, .rxd, .enb_out, .cteq9, .cteq7, .cteq15, .rdy,
    .clr, .clr10, .enb10, .clr16, .enb16, .sh_ld, .valid, .ferr, .oerr);

    shreg U_SHREG(.clk, .rst, .rxd, .sh_ld, .data);

    rate_enb #(.RATE_HZ(ENB_RATE)) U_RATE(.clk, .rst, .clr, .enb_out);

    count10 U_CT10(.clk, .rst, .enb(enb10), .clr(clr10), .cteq9);

    count16 U_CT16(.clk, .rst, .enb(enb16), .clr(clr16), .cteq15, .cteq7);

endmodule
