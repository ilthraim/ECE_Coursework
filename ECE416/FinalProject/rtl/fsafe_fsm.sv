module fsafe_fsm (
    input logic clk, rst, txen, bp_enb,
    output logic txen_fail
    );
    parameter BPLIMIT = 512;
    localparam CW = $clog2(BPLIMIT+1);

    logic [CW-1:0] bpcount, bpcount_next;

    typedef enum logic [1:0] {TX_IDLE, TX_ACTIVE, TX_FAIL} states_t;

    states_t state, next;

    always_ff @(posedge clk) begin
        if (rst) begin
            bpcount <= 0;
            state <= TX_IDLE;
        end
        else begin
            bpcount <= bpcount_next;
            state <= next;
        end
    end

    always_comb begin
        bpcount_next = bpcount;
        next = state;
        txen_fail = 0;
        case (state)
            TX_IDLE: begin
                bpcount_next = 0;
                if (txen) next = TX_ACTIVE;
                else next = TX_IDLE;
            end
            TX_ACTIVE: begin
                if (bpcount >= BPLIMIT) next = TX_FAIL;
                else if (txen == 0) next = TX_IDLE;
                else if (bp_enb) begin
                    bpcount_next = bpcount + 1;
                    next = TX_ACTIVE;
                end
                else next = TX_ACTIVE;
            end
            TX_FAIL: begin
                txen_fail = 1;
                next = TX_FAIL;
            end
        endcase
    end

endmodule: fsafe_fsm
