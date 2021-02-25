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