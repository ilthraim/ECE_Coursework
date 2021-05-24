//-----------------------------------------------------------------------------
// Module Name   : manchester_xmit
// Project       : Manchester Transmitter
//-----------------------------------------------------------------------------
// Author        : Ethan Miller & John Burk
// Created       : April 2021
//-----------------------------------------------------------------------------
// Description   : Top level module integrating all inputs and outputs,
// as well as the shreg, rate enbs, and FSM. Counters done in RTL within
// FSM
//-----------------------------------------------------------------------------

module manchester_xmit #(parameter BIT_RATE = 50000, parameter IDLE_BITS = 2) (
    input logic clk, rst, valid, [7:0] data,
    output logic rdy, txd, txen
);

    localparam ENB_RATE = 2 * BIT_RATE;

    logic enb_out, sh_idle, sh_ld, sh_en, shreg_out, br_st, ct_clr, ct_enb, ib_ct_clr, ib_ct_enb;
    logic [3:0] ct, ib_ct;

    typedef enum logic [1:0] {IDLE, TXBIT_LOW, TXBIT_HIGH, IDLE_TX} states_t;
    states_t state, next;

    rate_enb #(ENB_RATE) U_RATE  (.clk, .rst, .enb_out, .clr(br_st));
    shreg_man_txd U_SHREG (.clk, .rst, .sh_idle, .sh_ld, .sh_en, .data, .txd(shreg_out));


    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            ct <= 0;
            ib_ct <= 0;
        end else begin
            state <= next;

            if (ib_ct_clr) ib_ct <= 0;
            else if (ib_ct_enb)
                ib_ct <= ib_ct + 1;

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
        ib_ct_clr = 1'b0;
        ib_ct_enb = 1'b0;
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
                        rdy = 1'b1;
                        if (valid) begin
                            sh_ld = 1'b1;
                            br_st = 1'b1;
                            ct_clr = 1'b1;
                            next = TXBIT_LOW;

                        end else begin
                            next = IDLE_TX;
                            ib_ct_clr = 1'b1;
                        end
                    end
                end
                else next = TXBIT_HIGH;
            end

            IDLE_TX: begin
                txen = 1'b1;
                txd = 1'b1;
                if (enb_out) begin
                    if (ib_ct == (IDLE_BITS))
                        next = IDLE;
                    else begin
                        ib_ct_enb = 1'b1;
                        next = IDLE_TX;
                    end
                end else next = IDLE_TX;
            end

        endcase
    end


endmodule
