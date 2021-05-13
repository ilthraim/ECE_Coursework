module tiu_fsm(
    input logic clk, rst, xvalid, xsend, mx_rdy, ACK_received, ACK_needed, MAC, dest_addr, ftype, cardet,
    output logic xrdy, xbusy, mx_valid, xerrcnt, write_en, write_address, read_address, read_en, [2:0] data_select);

    typedef enum logic [4:0] {IDLE, LOAD_PREAMBLE, WAIT_DIFS, WAIT_DIFS_RANDOM, LOAD_SFD, LOAD_INFO, LOAD_SAMPLE, WAIT_SIFS, LOAD_FCS, LOAD_EOF, TRANSMIT, ACK_WAIT} states_t;
    states_t state, next;
    logic attempt_ct, attempt_ct_en, attempt_ct_clr, preamble_ct, preamble_ct_en, preamble_ct_clr, data_ct, data_ct_en, data_ct_clr, watchdog_ct, watchdog_ct_en, watchdog_ct_clr, xerrcnt_ct, xerrcnt_ct_en, xerrcnt_ct_clr, crc_en;
    localparam DIFS = 80;
    localparam SIFS = 40;
    localparam SLOT = 8;
    localparam ACK_TIMEOUT = 256;
    localparam MAX_ATTEMPTS = 5;
    parameter PREAMBLE_LENGTH = 2;
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            write_address <= 0;
            read_address <= 0;
            attempt_ct <= 0;
            preamble_ct <= 0;
            data_ct <= 0;
            watchdog_ct <= 0;
            xerrcnt_ct <= 0;
        end else begin
            state <= next;
            if (preamble_ct_clr) preamble_ct <= 0;
            else if (preamble_ct_en) preamble_ct <= preamble_ct + 1;
            if (watchdog_ct_clr) watchdog_ct <= 0;
            else if (watchdog_ct_en) watchdog_ct <= watchdog_ct + 1;
            if (attempt_ct_clr) attempt_ct <= 0;
            else if (attempt_ct_en) attempt_ct  <= attempt_ct + 1;
            if (data_ct_clr) data_ct <= 0;
            else if (data_ct_en) data_ct <= data_ct + 1;
            if (xerrcnt_ct_clr) xerrcnt_ct <= 0;
            else if (xerrcnt_ct_en) xerrcnt_ct <= xerrcnt_ct + 1;
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                xrdy = 1;
                if (xvalid || ACK_needed) begin
                    if (cardet) next = WAIT_DIFS;
                    else begin
                        preamble_ct_clr = 1;
                        next = LOAD_PREAMBLE;
                    end
                end else next = IDLE;
            end
            WAIT_DIFS: begin
                watchdog_ct_en = 1;
                if (watchdog_ct == DIFS * 8) begin
                    if (cardet) begin
                        watchdog_ct_clr = 1;
                        next = WAIT_DIFS_RANDOM;
                    end else next = LOAD_PREAMBLE;
                end else next = WAIT_DIFS;
            end
            WAIT_DIFS_RANDOM: begin
                watchdog_ct_en = 1;
                if (watchdog_ct == (DIFS + SLOT * $urandomrange(1, 64)) * 8) begin
                    if (cardet) next = WAIT_DIFS_RANDOM;
                    else next = LOAD_PREAMBLE;
                end else next = WAIT_DIFS_RANDOM;
            end
            LOAD_PREAMBLE: begin
                write_en = 1;
                data_select = 3'd0;
                write_address = write_address + 1;
                if (preamble_ct == PREAMBLE_LENGTH) next = LOAD_SFD;
                else begin
                    preamble_ct_en = 1;
                    next = LOAD_PREAMBLE;
                end
            end
            LOAD_SFD: begin
                write_en = 1;
                data_select = 3'd1;
                write_address = write_address + 1;
                next = LOAD_INFO;
            end
            LOAD_INFO: begin
                write_en = 1;
                data_select = 3'd2;
                write_address = write_address + 1;
                data_select = 3'd3;
                write_address = write_address + 1;
                data_select = 3'd4;
                write_address = write_address + 1;
                if (ACK_needed) next = WAIT_SIFS;
                else next = LOAD_SAMPLE;
            end
            WAIT_SIFS: begin
                watchdog_ct_en = 1;
                if (watchdog_ct == SIFS * 8) next = LOAD_FCS;
                else next = WAIT_SIFS;
            end
            LOAD_SAMPLE: begin
                xrdy = 1;
                data_select = 3'd5;
                write_address = write_address + 1;
                if (xvalid) begin
                    data_ct_en = 1;
                    write_en = 1;
                    if (data_ct > 255 || xsend) begin
                        if (ftype >= 1) next = LOAD_FCS;
                        else next = LOAD_EOF;
                    end else next = LOAD_SAMPLE;
                end else next = LOAD_SAMPLE;
            end
            LOAD_FCS: begin
                write_en = 1;
                data_select = 3'd6;
                write_address = write_address + 1;
                next = LOAD_EOF;
            end
            LOAD_EOF: begin
                write_en  = 1;
                data_select = 3'd7;
                write_address = write_address + 1;
                next = TRANSMIT;
            end
            TRANSMIT: begin
                read_en = 1;
                read_address = read_address + 1;
                if (mx_rdy) begin
                    mx_valid = 1;
                    if (write_address == read_address) begin
                        if (ftype == 2) begin
                            watchdog_ct_clr = 1;
                            next = ACK_WAIT;
                        end else begin
                            crc_en = 1;
                            next = IDLE;
                        end
                    end else begin
                        crc_en = 1;
                        next = IDLE;
                    end
                end else next = TRANSMIT;
            end
            ACK_WAIT: begin
                watchdog_ct_en = 1;
                if (watchdog_ct == SIFS * 8) begin
                    if (ACK_received) begin
                        crc_en = 1;
                        next = IDLE;
                    end else begin
                        preamble_ct_clr = 1;
                        attempt_ct_en = 1;
                        if (attempt_ct == 5) begin
                            xerrcnt_ct_en = 1;
                            crc_en = 1;
                            next = IDLE;
                        end else next = LOAD_PREAMBLE;
                    end
                end else next = ACK_WAIT;
            end
            default: next = IDLE;
        endcase
    end
endmodule
