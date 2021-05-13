`timescale 1ns / 1ps

module wimpfi_top(
    input logic clk, rst, rxd, a_rxd, [7:0] mac,
    output logic txd, txen, a_txd, cfgclk
    );
    logic[7:0] ack_addr, xdata,dest_addr,ftype,uart_in,xerrcnt,rdata,rerrcnt;
    logic xvalid, xrdy, rvalid, rrdy, xsnd, ACK_received,ACK_needed,xbusy,cardet,ferr,oerr;
    assign cfgclk = 0;
    
    xmit_top u_xmit_top(.clk, .rst, .xvalid, .xsend(xsnd), .cardet, .ACK_received, .ACK_needed, .mac, .ack_addr, .xdata, .dest_addr, .ftype, .uart_in,
    .txd, .txen, .xrdy, .xbusy, .xerrcnt);
    
    rcvr_top u_rcvr_top(.clk, .rst, .rxd, .rrdy, .MAC(mac),
    .cardet, .ACK_needed, .ACK_received, .rvalid, .rdata, .rerrcnt);
    
    uart_xmit u_uart_xmit(.clk100MHz(clk), .rst, .valid(rvalid), .data(rdata),
    .rdy(rrdy), .txd(a_txd));
    
    uart_rxd u_uart_rxd(.clk, .rst, .rxd(a_rxd), .rdy(xrdy),
    .valid(xvalid), .xsnd, .ferr, .oerr, .data(uart_in));
endmodule
