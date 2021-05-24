//-----------------------------------------------------------------------------
// Module Name   : wimpfi_top
// Project       : wimpFi
//-----------------------------------------------------------------------------
// Author        : Zachary Martin
// Created       : May 2021
//-----------------------------------------------------------------------------
// Description   : Top level module integrating all inputs and outputs,
// as well as the rcvr and xmit top level modules, failsafe, sevenseg, 
// and uart rxd/txd
//-----------------------------------------------------------------------------

module wimpfi_top(
    input logic clk, rst, rxd, a_rxd,backoff,failsafe,[1:0]ftype_a, [7:0] mac,
    output logic txd,dp_n, a_txd, cfgclk, cfgdat, rcv_led,[7:0]an_n,[6:0]segs_n
    );
    
    parameter BIT_RATE = 50000;
    logic[7:0] ack_addr, xdata,dest_addr,ftype,uart_in,rdata,ack_frame_addr;
    logic xvalid,failsafe_txen, txen_fail,ack_rcv_clr, xrdy, rvalid,txen_safe, rrdy, xsnd,xsend, ACK_received,ACK_needed,xbusy,cardet,ferr,oerr,txen,ack_sent,backoff_cardet,valid_cardet,cardet_final;
    logic[3:0] xerrcnt,rerrcnt;
    logic[6:0] d7, d6, d5, d4, d3, d2, d1, d0;
    
    //    assign cfgclk = !txen; //if no failsafe is implemented
    assign cfgdat = !txen_fail;
    assign cfgclk = !failsafe_txen; //for failsafe simulation 
    assign xsend = xvalid && (uart_in == 8'h04);
    assign cardet_final = backoff || valid_cardet; //for backoff simulation
    assign rcv_led = cardet_final;
    assign d0 = {3'b000,xerrcnt};
    assign d1 = {3'b000,rerrcnt};
    assign d2 = 7'b1000000;
    assign d3 = 7'b1000000;
    assign d4 = 7'b1000000;
    assign d5 = 7'b1000000;
    assign d6 = 7'b1000000;
    assign d7 = 7'b1000000;
    assign failsafe_txen = txen || failsafe; //for failsafe simulation
    
    //Transmitter Top
    xmit_top #(.BIT_RATE(BIT_RATE)) u_xmit_top(.clk, .rst, .xvalid, .xsend, .cardet(cardet_final), .ACK_received, .ACK_needed, .mac, .ack_addr, .xdata, .ftype, .uart_in,
    .txd, .txen, .xrdy, .xbusy, .xerrcnt, .ack_frame_addr,.ack_sent,.ack_rcv_clr);
    
    //Receiver Top
    rcvr_top #(.BIT_RATE(BIT_RATE)) u_rcvr_top(.clk, .rst, .rxd, .rrdy, .MAC(mac),.ack_rcv_clr,
    .cardet, .ACK_needed, .ACK_received, .rvalid, .rcvr_data(rdata), .rerrcnt, .ack_frame_addr,.ack_sent,.valid_cardet);
    
    //UART Transmitter
    uart_xmit u_uart_xmit(.clk100MHz(clk), .rst, .valid(rvalid), .data(rdata),
    .rdy(rrdy), .txd(a_txd));
    
    //Fail Safe
     fsafe fail_safe(.clk, .rst, .txen(failsafe_txen),.txen_safe, .txen_fail);
     
    //UART Receiver
    uart_rxd u_uart_rxd(.clk, .rst, .rxd(a_rxd), .rdy(xrdy),
    .valid(xvalid), .xsnd, .ferr, .oerr, .data(uart_in));
    
    //Seven-Segment Control
    sevenseg_ctl U_CTRL (.clk, .rst, .d7, .d6, .d5, .d4, .d3, .d2, .d1, .d0,
        .segs_n, .dp_n, .an_n);
    
    //Used for the sake of debugging. Not actively used now
    always_comb begin
    if(ftype_a == 2'b00) ftype = 8'h30;
    else if (ftype_a == 2'b01) ftype = 8'h31;
    else if (ftype_a == 2'b10) ftype = 8'h32;
    else ftype = 8'h33;
    end
    
endmodule
