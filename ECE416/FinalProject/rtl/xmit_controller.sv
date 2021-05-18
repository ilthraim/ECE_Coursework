module xmit_controller(
    input logic clk, enb_out_8, rst, enb_out_uart, enb_out_mx, xvalid, xsend, mx_rdy, ACK_received, ACK_needed, cardet, [7:0]MAC, ftype, uart_in,
    output logic crc_en, crc_clr, crc_xmit, xrdy, xbusy, mx_valid, xerrcnt, write_en, read_en,[7:0] dest_addr, [2:0] data_select, [8:0] write_address, read_address);

    typedef enum logic [4:0] {IDLE, LOAD_PREAMBLE, WAIT_DIFS, WAIT_DIFS_RANDOM, LOAD_SFD, LOAD_SFD_DUMMY, LOAD_DEST_ADDR, LOAD_SRC_ADDR,LOAD_FRAME_TYPE, LOAD_SAMPLE, WAIT_SIFS, LOAD_FCS, LOAD_EOF, TRANSMIT, TRANSMIT_CRC, ACK_WAIT} states_t;
    states_t state, next;
    logic attempt_ct,ftype_set,ftype_clr,read_ct_clr, read_ct_en, attempt_ct_en, attempt_ct_clr, preamble_ct_en, preamble_ct_clr, data_ct_en, data_ct_clr, watchdog_ct_en, watchdog_ct_clr, xerrcnt_ct, xerrcnt_ct_en, xerrcnt_ct_clr;
    logic [31:0] watchdog_ct;
    logic [8:0] write_address_next;
    logic [8:0] read_address_next,preamble_ct;
    logic [7:0] frame_type;
    logic [5:0] data_ct, read_ct, rand_wait;
    logic [2:0] data_select_next;
    logic clr_dest_addr, set_dest_addr;
    logic [5:0] rand_wait_ctr;
    logic [1:0] ct3;
    logic set_rand_wait;
    localparam DIFS = 80;
    localparam SIFS = 40;
    localparam SLOT = 8;
    localparam ACK_TIMEOUT = 256;
    localparam MAX_ATTEMPTS = 5;

    parameter PREAMBLE_LENGTH = 1;
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            write_address <= 0;
            read_address <= 0;
            attempt_ct <= 0;
            preamble_ct <= 0;
            data_ct <= 0;
            read_ct <= 0;
            watchdog_ct <= 0;
            xerrcnt_ct <= 0;
            data_select <= 0;
            dest_addr <= 0;
            frame_type <= 0;
            rand_wait_ctr = 0;
            ct3 = 0;
        end else begin
            state <= next;
            write_address <= write_address_next;
            data_select <= data_select_next;
            read_address <= read_address_next;
            ct3 <= ct3 + 1;
            if (ct3 == 2'd2) rand_wait_ctr <= rand_wait_ctr + 1;
            if (set_rand_wait) rand_wait <= rand_wait_ctr;
            if (preamble_ct_clr) preamble_ct <= 0;
            else if (preamble_ct_en) preamble_ct <= preamble_ct + 1;
            if (watchdog_ct_clr) watchdog_ct <= 0;
            else if (watchdog_ct_en) watchdog_ct <= watchdog_ct + 1;
            if (attempt_ct_clr) attempt_ct <= 0;
            else if (attempt_ct_en) attempt_ct  <= attempt_ct + 1;
            if (data_ct_clr) data_ct <= 0;
            else if (data_ct_en) data_ct <= data_ct + 1;
            if (read_ct_clr) read_ct <= 0;
            else if(read_ct_en) read_ct <= read_ct + 1;
            if (xerrcnt_ct_clr) xerrcnt_ct <= 0;
            else if (xerrcnt_ct_en) xerrcnt_ct <= xerrcnt_ct + 1;
            if(clr_dest_addr) dest_addr <= 0;
            else if(set_dest_addr) dest_addr <= uart_in;
            if(ftype_clr) frame_type <= 0;
            else if(ftype_set) frame_type <= uart_in;
        end
    end

    always_comb begin
        write_address_next = write_address;
        data_select_next = data_select;
        read_address_next = read_address;
        xrdy = 1;
        ftype_clr = 0;
        ftype_set = 0;
        mx_valid = 0;
        set_dest_addr = 0;
        clr_dest_addr = 0;
        write_en = 0;
        read_en = 0;
        preamble_ct_en = 0;
        read_ct_en = 0;
        data_ct_en = 0;
        read_ct_clr = 0;
        data_ct_clr = 0;
        preamble_ct_clr = 0;
        watchdog_ct_en = 0;
        watchdog_ct_clr = 0;
        crc_clr = 0;
        crc_en = 0;
        crc_xmit = 0;
        set_rand_wait = 0;
        case (state)
            IDLE: begin
                //xrdy = 1;
//                if (xvalid || ACK_needed) begin
//                    if (cardet) next = WAIT_DIFS;
//                    else begin
//                        preamble_ct_clr = 1;
//                        next = LOAD_SAMPLE;
//                    end
//                end else next = IDLE;
                write_address_next = 0;
                read_address_next = 0;
                watchdog_ct_clr = 1;
                read_ct_clr = 1;
                data_ct_clr = 1;
                preamble_ct_clr = 1;
                data_select_next = 3'd0;
                next = LOAD_PREAMBLE;
            end
            WAIT_DIFS: begin
                if(enb_out_8) begin
                    watchdog_ct_en = 1;
                    if (watchdog_ct == DIFS * 8) begin
                        if (cardet) begin
                            watchdog_ct_clr = 1;
                            set_rand_wait = 1;
                            next = WAIT_DIFS_RANDOM;
                        end else next = TRANSMIT;
                    end else next = WAIT_DIFS;
                end else next = WAIT_DIFS;
                if(ACK_received)next = IDLE;
            end
            WAIT_DIFS_RANDOM: begin
                if(enb_out_8) begin
                    watchdog_ct_en = 1;
                    if (watchdog_ct == (((DIFS + SLOT) * rand_wait)) * 8) begin
                        if (cardet) next = WAIT_DIFS_RANDOM; //should rand_wait be re-randomzied here?
                        else next = TRANSMIT;
                        watchdog_ct_clr = 1;
                    end else next = WAIT_DIFS_RANDOM;
                end else next = WAIT_DIFS_RANDOM;
                if(ACK_received)next = IDLE;
            end
            LOAD_PREAMBLE: begin
                crc_clr = 1;
                write_en = 1;
                //mx_valid = 1;
                data_select_next = 3'd0;
                write_address_next = write_address + 1;
               //if(mx_rdy) begin
                if (preamble_ct == PREAMBLE_LENGTH) begin
                    next = LOAD_SFD;
                    data_select_next = 3'd1;
                end
                    else begin
                        
                        preamble_ct_en = 1;
                        next = LOAD_PREAMBLE;
                    end
               //end
               //else next = LOAD_PREAMBLE;
            end
            LOAD_SFD: begin
                write_en = 1;
                data_select_next = 3'd1;
                //mx_valid = 1;
                write_address_next = write_address + 1;
                next = LOAD_DEST_ADDR;
            end

            LOAD_DEST_ADDR: begin   //load in dest addr, src addr, ftype
                //mx_valid = 1;
                //if(mx_rdy) begin
                //if(enb_out_uart) begin
                data_select_next = 3'd5;
                        if(xvalid)begin
                            write_en = 1;
                            write_address_next = write_address + 1;
                            set_dest_addr = 1; //grab dest addr from uart input. not needed
//                            if(data_select == 4) begin //or 4?
//                                if (ACK_needed) next = WAIT_SIFS;
//                                else next = LOAD_SAMPLE;
//                            end
//                            else next = LOAD_DEST_ADDR;
                            data_select_next = 3'd5;
                            next = LOAD_SRC_ADDR;
                        end else next = LOAD_DEST_ADDR;
                 //end //enb out
                 //else next = LOAD_INFO;
                  //  end
               // else next = LOAD_INFO;   
            end
            LOAD_SRC_ADDR: begin
            data_select_next = 3'd5;
                if(xvalid)begin
                    data_select_next = 3'd4;
                    write_en = 1;
                    write_address_next = write_address + 1;
                    next = LOAD_FRAME_TYPE;
                end
                else next = LOAD_SRC_ADDR;
            end
            LOAD_FRAME_TYPE: begin
                data_select_next = 3'd5;
                if(xvalid)begin
                    ftype_set = 1;
                    data_select_next = 3'd5;
                    write_en = 1;
                    write_address_next = write_address + 1;
                    next = LOAD_SAMPLE;
                end
                else next = LOAD_FRAME_TYPE;
            end
            WAIT_SIFS: begin
                if(enb_out_8) begin
                    watchdog_ct_en = 1;
                    if (watchdog_ct == SIFS * 8) next = LOAD_FCS;
                    else next = WAIT_SIFS;
                end
                else next = WAIT_SIFS;
            end
            //load uart data into bram
            LOAD_SAMPLE: begin
               // xrdy = 1;
              // if(enb_out_uart) begin
                    data_select_next = 3'd5; 
                    if (xvalid) begin
                        write_address_next = write_address + 1;
                        data_ct_en = 1;
                        write_en = 1; 
                        if (data_ct > 255 || xsend) begin
//                            if (frame_type != 8'h30) next = LOAD_FCS;
//                            else next = TRANSMIT; //now going to transmit crc after reading out bram
                              next = TRANSMIT;
                        end else next = LOAD_SAMPLE;
                    end else next = LOAD_SAMPLE;
                //end else next = LOAD_SAMPLE;
            end
            LOAD_FCS: begin
                write_en = 1;
                data_select_next = 3'd6;
                write_address_next = write_address + 1;
                next = TRANSMIT;
            end
            //not NEEDED STATE, NOT USING CURRENTLY
            LOAD_EOF: begin
                write_en  = 1;
                data_select_next = 3'd7;
                write_address_next = write_address + 1;
                next = TRANSMIT;
            end
            TRANSMIT: begin
                xrdy = 0;
                if(cardet) next = WAIT_DIFS;
                else begin
                    if(enb_out_mx) begin
                        if (mx_rdy) begin
                        read_ct_en = 1;
                        read_en = 1;
                        read_address_next = read_address + 1;
                        mx_valid = 1;
                        if (read_ct >= 3) begin
                            crc_en = 1;
                        end
                        //this part is not right. won't work for ack as you will be cutting off last byte bc no ctrl+D to cut off. enable data_ct in preamble and sfd?
                            if (data_ct + 4 == read_ct) begin //done reading thru bram. 
                                if (frame_type != 8'h30) begin //need crc
                                    watchdog_ct_clr = 1;
                                    next = TRANSMIT_CRC;
                                end else begin
                                    next = IDLE;
                                end
                            end else begin
                                next = TRANSMIT;
                            end
                        end else next = TRANSMIT;
                    end
                    else next = TRANSMIT;
                    end //for cardet
            end
            TRANSMIT_CRC: begin
                if (enb_out_mx) begin
                    if (mx_rdy) begin
                        crc_xmit = 1;
                        mx_valid = 1;
                        if(frame_type ==8'h32) next = ACK_WAIT; //need ack frame back
                        else next = IDLE;
                    end else next = TRANSMIT_CRC;
                end else next = TRANSMIT_CRC;
            end
            ACK_WAIT: begin
                if(enb_out_8) begin
                    watchdog_ct_en = 1;
                    if (watchdog_ct == SIFS * 8) begin
                        if (ACK_received) begin
                            next = IDLE;
                        end else begin
                            preamble_ct_clr = 1;
                            attempt_ct_en = 1;
                            if (attempt_ct == 5) begin
                                xerrcnt_ct_en = 1;
                                next = IDLE;
                            end else begin
                            next = TRANSMIT;
                            crc_clr = 1;
                            read_address_next = 0;
                            watchdog_ct_clr = 1;
                            read_ct_clr = 1;
                            end
                        end
                    end else next = ACK_WAIT;
                end else next = ACK_WAIT;
            end
            default: next = IDLE;
        endcase
    end
endmodule
