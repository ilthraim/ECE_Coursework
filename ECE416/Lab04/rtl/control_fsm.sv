
module control_fsm(
    input logic clk, rst, rxd, enb_out, cteq9, cteq7, cteq15, rdy,
    output logic clr, clr10, enb10, clr16, enb16, sh_ld, valid, ferr, oerr);

    logic set_valid, clr_valid, set_ferr, clr_ferr, set_oerr, clr_oerr;

    typedef enum logic [1:0] {WAIT_RDY, START_TENT, RCV_BIT} states_t;

    states_t state, next;

    always_ff @(posedge clk) begin
        if (rst)
            state <= WAIT_RDY;
        else
            state <= next;

        if (rst || clr_valid)
            valid <= 0;
        else if (set_valid)
            valid <= 1;

        if (rst || clr_ferr)
            ferr <= 0;
        else if (set_ferr)
            ferr <= 1;

        if (rst || clr_oerr)
            oerr <= 0;
        else if (set_oerr)
            oerr <= 1;
    end

    always_comb begin
        next = WAIT_RDY;
        set_valid = 0;
        clr_valid = 0;
        set_ferr = 0;
        clr_ferr = 0;
        set_oerr = 0;
        clr_oerr = 0;
        clr = 0;
        clr10 = 0;
        enb10 = 0;
        clr16 = 0;
        enb16 = 0;
        sh_ld = 0;

        case (state)
            WAIT_RDY: begin
                if (rdy) begin
                    clr_valid = 1;
                    clr_oerr = 1;
                    if (enb_out && ~rxd) begin
                        clr16 = 1;
                        next = START_TENT;
                    end else next = WAIT_RDY;
                end else begin
                    if (enb_out && ~rxd) begin
                        clr16 = 1;
                        next = START_TENT;
                    end else next = WAIT_RDY;
                end
            end

            START_TENT: begin
                if (enb_out) begin
                    if (cteq7) begin
                        if (rxd) next = WAIT_RDY;
                        else begin
                            clr10 = 1;
                            clr16 = 1;
                            clr_ferr = 1;
                            if (valid) begin
                                set_oerr = 1;
                                next = RCV_BIT;
                            end else next = RCV_BIT;
                        end
                    end else begin
                        enb16 = 1;
                        next = START_TENT;
                    end
                end else next = START_TENT;
            end

            RCV_BIT: begin
                if (enb_out) begin
                    if (cteq15) begin
                        sh_ld = 1;
                        clr16 = 1;
                        if (cteq9) begin
                            if (rxd) begin
                                set_valid = 1;
                                next = WAIT_RDY;
                            end else begin
                                set_ferr = 1;
                                next = WAIT_RDY;
                            end
                        end else begin
                            enb10 = 1;
                            next = RCV_BIT;
                        end
                    end else begin
                        enb16 = 1;
                        next = RCV_BIT;
                    end
                end else next = RCV_BIT;
            end
            
        endcase
    end

endmodule
