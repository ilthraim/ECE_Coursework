
module Lab04_top(
    input logic clk, rst, rdy, rxd,
    output logic dp_n, valid, ferr, oerr, [7:0] an_n, [6:0] segs_n, [7:0] data);
    
    logic rdy_db;
    logic [6:0] d1, d0;
    
    assign d1 = {3'd0, data[7:4]};
    assign d0 = {3'd0, data[3:0]};
    
    debounce U_DB(.clk, .pb(rdy), .rst, .pb_debounced(rdy_db));
    
    uart_rxd U_UART(.clk, .rst, .rxd, .rdy(rdy_db), .valid, .ferr, .oerr, .data);
    
    sevenseg_ctl U_SVNSEG(.clk, .rst, .d7(7'd0), .d6(7'd0), .d5(7'd0), .d4(7'd0), .d3(7'd0), .d2(7'd0), .d1, .d0, 
    .segs_n, .dp_n, .an_n);
    
endmodule
