module lab05_top(
    input logic clk, rst, run_in, [5:0] length,
    output logic uart_out, txen, cardet, error, [7:0] leds);
    
    logic run_out, valid_xmit, rdy_xmit, txd, valid_rcvr, empty, rd_en;
    logic [7:0] data_xmit, data_rcvr, data_fifo;
    
    assign leds = data_fifo;
    
    single_pulser U_SP(.clk, .din(run_in), .d_pulse(run_out));
    mxtest_21 U_MXTEST(.clk, .rst, .send(run_out), .rdy(rdy_xmit), .frame_len(length), .data(data_xmit), .valid(valid_xmit));
    manchester_xmit #(.BIT_RATE(50000)) U_XMIT(.clk, .rst, .valid(valid_xmit), .data(data_xmit), .rdy(rdy_xmit), .txd, .txen);
    mx_rcvr #(.BIT_RATE(50000)) U_RCVR(.clk, .rst, .rxd(txd), .valid(valid_rcvr), .cardet, .error, .data(data_rcvr));
    fwft_fifo U_FIFO(.clk, .srst(rst), .din(data_rcvr), .wr_en(valid_rcvr), .rd_en, .dout(data_fifo), .empty);
    uart_xmit #(.BAUD_RATE(9600)) U_UART_XMIT(.clk100MHz(clk), .rst, .valid(!empty), .data(data_fifo), .rdy(rd_en), .txd(uart_out));
    
endmodule
