`timescale 1ns / 1ps

module wimpfi_top(
    input logic clk, rst, rxd, a_rxd,[1:0]ftype_a, [7:0] mac,
    output logic txd, txen, a_txd, cfgclk
    );
    logic[7:0] ack_addr, xdata,dest_addr,ftype,uart_in,xerrcnt,rdata,rerrcnt;
    logic xvalid, xrdy, rvalid, rrdy, xsnd,xsend, ACK_received,ACK_needed,xbusy,cardet,ferr,oerr;
    assign cfgclk = 0;
    assign xsend = xvalid && (uart_in == 8'h04);
    xmit_top u_xmit_top(.clk, .rst, .xvalid, .xsend, .cardet, .ACK_received, .ACK_needed, .mac, .ack_addr, .xdata, .ftype, .uart_in,
    .txd, .txen, .xrdy, .xbusy, .xerrcnt);
    
    rcvr_top u_rcvr_top(.clk, .rst, .rxd, .rrdy, .MAC(mac),
    .cardet, .ACK_needed, .ACK_received, .rvalid, .rdata, .rerrcnt);
    
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
