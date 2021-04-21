module mx_rcvr_fsm(
    input logic clk, rst, enb16, enb8, one_out, zero_out, h_out, l_out, SFD_out, pre_out,
    output logic valid, cardet, error, clr16, clr8, sh_ld, sh_in);

    typedef enum logic [2:0] {WAIT_PRE, WAIT_SFD, WAIT_BIT, RCV_BIT, WAIT_POST_BIT, WAIT_EOF_NF, EOF_NF} states_t;
    states_t state, next;
    logic [3:0] count1;
    logic [6:0] count2;
    logic cteq7, ct1eq8, clr1, enb1, cteq3, cteq8, cttest, cteq127, cteq15, clr2, enb2, set_cardet, clr_cardet, set_err, clr_err, set_valid, clr_valid;

    assign cteq7 = (count1 == 4'd7);
    assign ct1eq8 = (count1 == 4'd8);
    assign cteq3 = (count2 == 7'd5);
    assign cteq8 = (count2 == 7'd8);
    assign cttest = (count2 == 7'd10);
    assign cteq15 = (count2 == 7'd13);
    assign cteq127 = (count2 == 7'd64);

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= WAIT_PRE;
            count1 <= 0;
            count2 <= 0;
            error <= 0;
            cardet <= 0;
            valid <= 0;
        end else begin
            state <= next;
            if (clr1) count1 <= 0;
            else if (enb1) count1 <= count1 + 1;
            if (clr2) count2 <= 0;
            else if (enb2) count2 <= count2 + 1;
            if (clr_cardet) cardet <= 0;
            else if (set_cardet) cardet <= 1;
            if (clr_err) error <= 0;
            else if (set_err) error <= 1;
            if (clr_valid) valid <= 0;
            else if (set_valid) valid <= 1;
        end
    end

    always_comb begin
        set_cardet = 0;
        set_err = 0;
        set_valid = 0;
        clr_cardet = 0;
        clr_err = 0;
        clr_valid = 0;
        clr16 = 0;
        clr8 = 0;
        sh_ld = 0;
        sh_in = 0;
        clr1 = 0;
        clr2 = 0;
        enb1 = 0;
        enb2 = 0;
        case (state)
            WAIT_PRE: begin
                if (pre_out) begin
                    clr16 = 1;
                    clr2 = 1;
                    set_cardet = 1;
                    clr_err = 1;
                    next = WAIT_SFD;
                end else next = WAIT_PRE;
            end
            WAIT_SFD: begin
                if (enb8) begin
                    if (pre_out) begin
                        clr2 = 1;
                        next = WAIT_PRE;
                    end else if (SFD_out) begin
                        clr8 = 1;
                        clr2 = 1;
                        clr1 = 1;
                        next = WAIT_BIT;
                    end else begin
                        if (cteq127) begin
                            clr_cardet = 1;
                            next = WAIT_PRE;
                        end else begin
                            enb2 = 1;
                            next = WAIT_SFD;
                        end
                    end
                end else next = WAIT_SFD;
            end
            WAIT_BIT: begin
                if (enb16) begin
                    if (cttest) begin
                        clr2 = 1;
                        next = RCV_BIT;
                    end else begin
                        enb2 = 1;
                        next = WAIT_BIT;
                    end
                end else next = WAIT_BIT;
            end
            RCV_BIT: begin
                if (enb16) begin
                    if (h_out || l_out) begin
                        sh_ld = 1;
                        sh_in = h_out;
                        if (cteq7) begin
                            set_valid = 1;
                            clr2 = 1;
                            next = WAIT_POST_BIT;
                            enb1 = 1;
                        end else begin
                            clr2 = 1;
                            enb1 = 1;
                            next = WAIT_POST_BIT;
                        end
                    end else begin
                        if (cteq3) begin
                            set_err = 1;
                            clr_cardet = 1;
                            next = WAIT_PRE;
                        end else begin
                            enb2 = 1;
                            next = RCV_BIT;
                        end
                    end
                end else next = RCV_BIT;
            end
            WAIT_POST_BIT: begin
                clr_valid = 1;
                if (enb16) begin
                    if (cteq15) begin
                        clr2 = 1;
                        if (ct1eq8) begin
                            clr16 = 1;
                            clr1 = 1;
                            next = EOF_NF;
                        end else next = RCV_BIT;
                    end else begin
                        enb2 = 1;
                        next = WAIT_POST_BIT;
                    end
                end else next = WAIT_POST_BIT;
            end
            WAIT_EOF_NF: begin

                if (enb16) begin
                    if (cteq8) next = EOF_NF;
                    else begin
                        enb2 = 1;
                        next = WAIT_EOF_NF;
                    end
                end else next = WAIT_EOF_NF;
            end
            EOF_NF: begin
                if (enb16) begin
                    if (h_out || l_out) begin
                        clr2 = 1;
                        next = RCV_BIT;
                    end else begin
                        if (one_out) begin
                            clr_cardet = 1;
                            next = WAIT_PRE;
                        end else next = EOF_NF;
                    end
                end else next =  EOF_NF;
            end
            default: next = WAIT_PRE;
        endcase
    end
endmodule
