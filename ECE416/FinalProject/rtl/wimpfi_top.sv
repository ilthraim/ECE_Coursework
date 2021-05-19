`timescale 1ns / 1ps

module wimpfi_top(
    input logic clk, rst, rxd, a_rxd,backoff,[1:0]ftype_a, [7:0] mac,
    output logic txd, a_txd, cfgclk, cfgdat, rcv_led
    );
    logic[7:0] ack_addr, xdata,dest_addr,ftype,uart_in,xerrcnt,rdata,rerrcnt,ack_frame_addr;
    logic xvalid, xrdy, rvalid, rrdy, xsnd,xsend, ACK_received,ACK_needed,xbusy,cardet,ferr,oerr,txen,ack_sent,backoff_cardet,valid_cardet,cardet_final;
    assign cfgclk = !txen;
    assign cfgdat = 1;
    assign xsend = xvalid && (uart_in == 8'h04);
    //assign backoff_cardet = cardet || backoff;
    assign cardet_final = backoff || valid_cardet;
    assign rcv_led = cardet_final;
    xmit_top u_xmit_top(.clk, .rst, .xvalid, .xsend, .cardet(cardet_final), .ACK_received, .ACK_needed, .mac, .ack_addr, .xdata, .ftype, .uart_in,
    .txd, .txen, .xrdy, .xbusy, .xerrcnt, .ack_frame_addr,.ack_sent);
    
    rcvr_top u_rcvr_top(.clk, .rst, .rxd, .rrdy, .MAC(mac),
    .cardet, .ACK_needed, .ACK_received, .rvalid, .rcvr_data(rdata), .rerrcnt, .ack_frame_addr,.ack_sent,.valid_cardet);
    
    uart_xmit u_uart_xmit(.clk100MHz(clk), .rst, .valid(rvalid), .data(rdata),
    .rdy(rrdy), .txd(a_txd));
    
    //a_rxd is from terminal input
    uart_rxd u_uart_rxd(.clk, .rst, .rxd(a_rxd), .rdy(xrdy),
    .valid(xvalid), .xsnd, .ferr, .oerr, .data(uart_in));
    //assign ftype = {{6'b000003},ftype_a};
    always_comb begin
    if(ftype_a == 2'b00) ftype = 8'h30;
    else if (ftype_a == 2'b01) ftype = 8'h31;
    else if (ftype_a == 2'b10) ftype = 8'h32;
    else ftype = 8'h33;
    end
endmodule
