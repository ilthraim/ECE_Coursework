//-----------------------------------------------------------------------------
// Module Name   : xmit_controller
// Project       : wimpFi
//-----------------------------------------------------------------------------
// Author        : Zachary Martin
// Created       : May 2021
//-----------------------------------------------------------------------------
// Description   : FSM for transmitter. Controls writing and reading to bram,
// backoff logic, re-transmit logic, and loads data into mx transmitter
//-----------------------------------------------------------------------------
module xmit_controller(
    input logic clk, enb_out_8, rst, enb_out_uart, enb_out_mx, xvalid, xsend, mx_rdy, ACK_received, ACK_needed, cardet, [7:0]MAC, ftype, uart_in,ack_frame_addr,
    output logic crc_en, crc_clr, crc_xmit, xrdy,ack_rcv_clr, ack_sent, xbusy, mx_valid, write_en, read_en,[7:0] dest_addr, frame_type, [2:0] data_select,[3:0]xerrcnt, [8:0] write_address, read_address);

    typedef enum logic [4:0] {IDLE, LOAD_DEST_ACK, LOAD_PREAMBLE, WAIT_DIFS, WAIT_DIFS_RANDOM, LOAD_SFD, LOAD_SFD_DUMMY, LOAD_DEST_ADDR, LOAD_SRC_ADDR,LOAD_FRAME_TYPE, LOAD_SAMPLE, TRANSMIT, TRANSMIT_CRC, ACK_WAIT,TRANSMIT_ACK,TRANSMIT_CRC_ACK} states_t;
    states_t state, next;
    
    logic ftype_set,set_rand_wait,ftype_clr,read_ct_clr, read_ct_en, attempt_ct_en, attempt_ct_clr, preamble_ct_en, preamble_ct_clr, data_ct_en, data_ct_clr, watchdog_ct_en, watchdog_ct_clr, xerrcnt_ct, xerrcnt_ct_en, xerrcnt_ct_clr;
    logic [31:0] watchdog_ct;
    logic [8:0] write_address_next,read_address_next,preamble_ct;
    logic [5:0] data_ct, read_ct, rand_wait,rand_wait_ctr;
    logic [2:0] data_select_next,attempt_ct;
    logic clr_dest_addr, set_dest_addr;
    logic [1:0] ct3;

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
            xerrcnt <= 0;
            ct3 <= 0;
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
            if (xerrcnt_ct_clr) xerrcnt <= 0;
            else if (xerrcnt_ct_en) xerrcnt <= xerrcnt + 1;
            if(clr_dest_addr) dest_addr <= 0;
            else if(set_dest_addr) dest_addr <= uart_in;
            if(ftype_clr) frame_type <= 0;
            else if(ftype_set) begin
                if(ACK_needed) frame_type <= 8'h33;
                else frame_type <= uart_in;
            end
        end
    end

    always_comb begin
        next = IDLE;
        write_address_next = write_address;
        data_select_next = data_select;
        read_address_next = read_address;
        ack_rcv_clr = 0;
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
        attempt_ct_en = 0;
        attempt_ct_clr = 0;
        ack_sent = 0;
        xerrcnt_ct_en = 0;
        xerrcnt_ct_clr = 0;

        case (state)
        //Clear paramters
            IDLE: begin
                write_address_next = 0;
                read_address_next = 0;
                watchdog_ct_clr = 1;
                read_ct_clr = 1;
                data_ct_clr = 1;
                preamble_ct_clr = 1;
                data_select_next = 3'd0;
                next = LOAD_PREAMBLE;
            end
            
            //Backoff state
            WAIT_DIFS: begin
                if(enb_out_8) begin
                    watchdog_ct_en = 1;
                    if (watchdog_ct >= DIFS*8) begin
                        if (cardet) begin
                            watchdog_ct_clr = 1;
                            set_rand_wait = 1;
                            next = WAIT_DIFS_RANDOM;
                        end else begin
                            if(ACK_needed)next = TRANSMIT_ACK;
                            else next = TRANSMIT;
                        end
                    end else next = WAIT_DIFS;
                end else next = WAIT_DIFS; 
            end
            
            //Backoff state
            WAIT_DIFS_RANDOM: begin
                if(enb_out_8) begin
                    watchdog_ct_en = 1;
                   // if (watchdog_ct >= 20) begin //used for sim
                    if (watchdog_ct >= ((DIFS+SLOT)*rand_wait*8)) begin //rand_wait is calculated by incrementing a counter every 3 clk cycles
                        if (cardet) next = WAIT_DIFS_RANDOM; 
                        else begin
                            if(ACK_needed)next = TRANSMIT_ACK;
                            else next = TRANSMIT;
                        end
                        watchdog_ct_clr = 1;
                    end else next = WAIT_DIFS_RANDOM;
                end else next = WAIT_DIFS_RANDOM;   
            end
            
            //Write preamble into bram
            LOAD_PREAMBLE: begin
                crc_clr = 1;
                write_en = 1;
                data_select_next = 3'd0;
                write_address_next = write_address + 1;
                if (preamble_ct == PREAMBLE_LENGTH) begin
                    next = LOAD_SFD;
                    data_select_next = 3'd1;
                end
                    else begin
                        preamble_ct_en = 1;
                        next = LOAD_PREAMBLE;
                    end
            end
            
            //write sfd into bram
            LOAD_SFD: begin
                write_en = 1;
                data_select_next = 3'd2; 
                write_address_next = write_address + 1;
                if(ACK_needed) data_select_next = 3'd2;
                next = LOAD_DEST_ADDR;
            end

            //write dest_addr into bram
            LOAD_DEST_ADDR: begin   
                if(!ACK_needed)data_select_next = 3'd5;
                else data_select_next = 3'd2; 
                        if(xvalid)begin
                            write_en = 1;
                            write_address_next = write_address + 1;
                            set_dest_addr = 1; //grab dest addr from uart input.
                            data_select_next = 3'd5;
                            next = LOAD_SRC_ADDR;
                        end else next = LOAD_DEST_ADDR;
                        if(ACK_needed && !ack_sent)begin
                            data_select_next = 3'd2;
                            next = LOAD_DEST_ACK;
                        end
            end
            
            //grab dest addr from receiver and write it into bram
            LOAD_DEST_ACK: begin                        
                write_en = 1;
                write_address_next = write_address + 1;
                data_select_next = 3'd3;
                next = LOAD_SRC_ADDR;
            end
            
            //Write src addr into bram
            LOAD_SRC_ADDR: begin
            if(!ACK_needed)data_select_next = 3'd5;
            else data_select_next = 3'd3;
                if(xvalid)begin
                    data_select_next = 3'd4;
                    write_en = 1;
                    write_address_next = write_address + 1;
                    next = LOAD_FRAME_TYPE;
                end
                else next = LOAD_SRC_ADDR;
                if(ACK_needed)begin
                    data_select_next = 3'd4; //load in MAC
                    write_en = 1;
                    write_address_next = write_address + 1;
                    next = LOAD_FRAME_TYPE;
                end
            end
            
            //write frame type into bram
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
                if(ACK_needed)begin
                    data_select_next = 3'd4; //load in ftype 
                    ftype_set = 1;
                    write_en = 1;
                    write_address_next = write_address + 1;
                    next = TRANSMIT_ACK;
                end
            end

            //load uart data into bram
            LOAD_SAMPLE: begin
                    data_select_next = 3'd5; 
                    if (xvalid) begin
                        write_address_next = write_address + 1;
                        data_ct_en = 1;
                        write_en = 1; 
                        if (data_ct > 255 || xsend) begin
                              next = TRANSMIT;
                        end else next = LOAD_SAMPLE;
                    end else next = LOAD_SAMPLE;
            end
            
            //load ack frame bytes into mx transmitter
            TRANSMIT_ACK: begin
                xrdy = 0;
                if(cardet) next = WAIT_DIFS;
                else begin
                    next = TRANSMIT_ACK;
                    if(mx_rdy) begin
                        read_ct_en = 1;
                            read_en = 1;
                            read_address_next = read_address + 1;
                            mx_valid = 1;
                            if (read_ct >= 3) begin
                                crc_en = 1;
                            end
                             if (data_ct + 5 == read_ct) begin //done reading thru bram. 
                                watchdog_ct_clr = 1;
                                ack_sent = 1;
                                read_ct_clr = 1;
                                next = TRANSMIT_CRC_ACK;
                            end else next = TRANSMIT_ACK;
                    end else next = TRANSMIT_ACK;
                end
            
            end
            
            //read out bram to mx transmitter
            TRANSMIT: begin
                xrdy = 0;
                if(cardet) next = WAIT_DIFS; //network is busy
                else begin
                    next = TRANSMIT;
                    if(enb_out_mx) begin
                        if (mx_rdy) begin
                            read_ct_en = 1;
                            read_en = 1;
                            read_address_next = read_address + 1;
                            mx_valid = 1;
                            if (read_ct >= 3) begin
                                crc_en = 1;
                            end
                            if (data_ct + 4 <= read_ct) begin //done reading thru bram. 
                                if (frame_type != 8'h30) begin //need crc
                                    watchdog_ct_clr = 1;
                                    read_ct_clr = 1;
                                    next = TRANSMIT_CRC;
                                end else next = IDLE;
                            end else next = TRANSMIT;
                        end
                    end else next = TRANSMIT; 
                end 
            end
            
            //Load checksum into mx transmitter
            TRANSMIT_CRC: begin
                crc_xmit = 1;  
                if(read_ct < 1) begin 
                    if (enb_out_mx) begin
                        if (mx_rdy) begin
                            mx_valid = 1;
                            read_ct_en = 1;
                            if(frame_type ==8'h32) next = ACK_WAIT; //need ack frame back
                            else next = TRANSMIT_CRC;
                        end else next = TRANSMIT_CRC;
                    end else next = TRANSMIT_CRC;
                end else begin
                    if(frame_type ==8'h32) next = ACK_WAIT; //need ack frame back
                     else next = IDLE;
                end
            end
            
            //Load checksum into mx transmitter for ack
            TRANSMIT_CRC_ACK: begin
                crc_xmit = 1;  
                mx_valid = 1;
                if(read_ct == 0) begin 
                        if (mx_rdy) begin
                            mx_valid = 1;
                            read_ct_en = 1;
                        end else next = TRANSMIT_CRC_ACK; //was transmit crc 5/19
                end else begin
                    if(frame_type ==8'h32) next = ACK_WAIT; //need ack frame back
                     else next = IDLE;
                end
            end
            
            //Re-transmit logic
            ACK_WAIT: begin
                if(enb_out_8) begin
                    watchdog_ct_en = 1;
                    if (watchdog_ct == ACK_TIMEOUT * 8) begin
                        if (ACK_received) begin
                            next = IDLE;
                            ftype_clr = 1;
                            ack_rcv_clr = 1;
                        end else begin
                            preamble_ct_clr = 1;
                            attempt_ct_en = 1;
                            if (attempt_ct == 5) begin //max attempts reached
                                xerrcnt_ct_en = 1;
                                next = IDLE;
                                attempt_ct_clr = 1;
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
