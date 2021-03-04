//-----------------------------------------------------------------------------
// Module Name   : xmit_fsm
// Project       : Lab02 - Serial Data Transmitter
//-----------------------------------------------------------------------------
// Author        : Ethan Miller, John Burk  <millerek@lafayette.edu, burkj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : FSM used to control the transmission of data using shift register, rate_enb,
// and counter.
// Description   : FSM Structure:
// Set rdy = 1. If valid = 1, set shift_ld (shift load), br_st (initialize rate_enb), and ct_clr (reset counter) = 1, 
// and move to TXBIT. Otherwise, set sh_idle (set txd = 1) to 1 and return to WTVALID (wait for valid). From TXBIT, 
// check if br_en (if the period set by the baud rate has elapsed). If no, return to TXBIT; if yes, 
// check if the counter has incremented through the entire data set + start and stop bits (ct_eql9). 
// If the ct_eql9, return to WTVALID. Otherwise, set sh_en (shift enable) and ct_en (count increment) to 1, and return to TXBIT. 
// This process will complete the valid-ready interface and ensure that 8 bits of data and 
// 2 start/stop bits are passed from the register through the datapath and transmitted through UART. 
//-----------------------------------------------------------------------------

module xmit_fsm (
    input logic clk, rst, valid, br_en, ct_eql9,
    output logic rdy, sh_ld, sh_idle, sh_en, br_st, ct_clr, ct_en
);
    typedef enum logic {WTVALID, TXBIT} states_t;
    states_t state, next;

    always_ff @(posedge clk)
        if (rst)
            state <= WTVALID;
        else
            state <= next;
            
    always_comb begin
        sh_ld = 1'b0;
        sh_idle = 1'b0;
        sh_en = 1'b0;
        br_st = 1'b0;
        ct_clr = 1'b0;
        ct_en = 1'b0;
        rdy = 1'b0;
        
        case (state)
            WTVALID:
                begin
                    rdy = 1'b1;
                    if (valid) begin
                        sh_ld = 1'b1;
                        br_st = 1'b1;
                        ct_clr = 1'b1;
                        next = TXBIT;
                    end else begin
                        sh_idle = 1'b1;
                        next = WTVALID;
                    end
                end
            TXBIT:
                begin
                    if (br_en) begin
                        if (ct_eql9) next = WTVALID;
                        else begin
                            sh_en = 1'b1;
                            ct_en = 1'b1;
                            next = TXBIT;
                        end 
                    end else next = TXBIT;
                end
        endcase
    end
        
                    
endmodule