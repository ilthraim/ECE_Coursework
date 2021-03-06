`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2021 01:04:09 PM
// Design Name: 
// Module Name: manchester_xmit
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


module manchester_xmit #(parameter BIT_RATE = 50000) (
    input logic clk, rst, valid, [7:0] data, 
    output logic rdy, txd, txen
);

    localparam ENB_RATE = 2 * BIT_RATE;
    
    logic enb_out, sh_idle, sh_ld, sh_en, shreg_out, br_st, ct_clr, ct_enb;
    logic [3:0] ct;
    
    typedef enum logic [1:0] {IDLE, TXBIT_LOW, TXBIT_HIGH} states_t;
    states_t state, next;
    
    rate_enb #(ENB_RATE) U_RATE  (.clk, .rst, .enb_out, .clr(br_st));
    shreg U_SHREG (.clk, .rst, .sh_idle, .sh_ld, .sh_en, .data, .txd(shreg_out));
    
    
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            ct <= 0;
        end else begin
            state <= next;
            
            if (ct_clr) ct <= 0;
            else if (ct_enb) begin
                if (ct == 4'd7)
                    ct <= 0;
                else ct <= ct + 1;
            end
        end
    end
    
    always_comb begin
        rdy = 1'b0;
        sh_idle = 1'b0;
        br_st = 1'b0;
        sh_ld = 1'b0;
        ct_clr = 1'b0;
        txd = 1'b1;
        txen = 1'b1;
        ct_enb = 1'b0;
        sh_en = 1'b0;
        case (state)
            IDLE: begin
                txen = 1'b0;
                rdy = 1'b1;
                if (valid) begin
                    sh_ld = 1'b1;
                    br_st = 1'b1;
                    ct_clr = 1'b1;
                    next = TXBIT_LOW;
                end
                else begin
                    sh_idle = 1'b1;
                    next = IDLE;
                end
            end
            
            TXBIT_LOW: begin
                txd = shreg_out;
                if (enb_out)
                    next = TXBIT_HIGH;
                else next = TXBIT_LOW;
            end
            
            TXBIT_HIGH: begin
                txd = ~shreg_out;
                if (enb_out) begin
                    if (ct != 4'd7) begin
                        ct_enb = 1'b1;
                        sh_en = 1'b1;
                        next = TXBIT_LOW;
                    end else begin
                        if (valid) begin
                            sh_ld = 1'b1;
                            br_st = 1'b1;
                            ct_clr = 1'b1;
                            next = TXBIT_LOW;
                            rdy = 1'b1;
                        end else next = IDLE;
                    end
                end
                else next = TXBIT_HIGH;
            end
        endcase
    end
    
    
endmodule
