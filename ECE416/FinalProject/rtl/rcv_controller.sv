//-----------------------------------------------------------------------------
// Module Name   : rcv_controller
// Project       : wimpFi
//-----------------------------------------------------------------------------
// Author        : Zachary Martin
// Created       : May 2021
//-----------------------------------------------------------------------------
// Description   : FSM for receiver. Controls writing and reading to bram,
// alerts transmitter of type 2 and 3 reception.
//-----------------------------------------------------------------------------
module rcv_controller #(parameter PREAMBLE_LENGTH = 1)(
    input logic clk, rst, valid, cardet, rrdy, ack_sent,ack_rcv_clr,
    input logic [7:0] MAC, data_bram,fcs, data_rcvr,crc_out,
    output logic write_en, read_en, ACK_needed, ACK_received, rvalid, crc_enb, crc_clr,crc_rcv,valid_cardet,
    output logic [3:0] rerrcount,
    output logic [8:0] write_address, read_address,ack_frame_addr
);

logic empty,rerrcount_clr,ftype_set,ftype_clr, rerrcount_en, read_type, read_dest_addr,data_ct_clr,data_ct_en,read_ct_clr,read_ct_en,ack_need_set,ack_need_clr,ack_rcv_set, set_ack_frame_addr, clr_ack_frame_addr;
logic [8:0] read_address_next, write_address_next,data_ct,read_ct, ack_frame_addr_next;
logic [7:0] frame_type,frame_type_next;

typedef enum logic [2:0] {IDLE, WRITE_SAMPLE, READ,READ_CRC} states_t;
states_t state, next;



    always_ff @(posedge clk) begin
        if (rst) begin
            write_address <= 0;
            read_address <= 0;
            rerrcount <= 0;
            data_ct <= 0;
            read_ct <= 0;
            state <= IDLE;
            ACK_needed <= 0;
            ACK_received <= 0;
            ack_frame_addr <= 0;
            frame_type <= 0;
        end
        else
            state <= next;
            write_address <= write_address_next;
            read_address <= read_address_next;
            if (data_ct_clr) data_ct <= 0;
            else if (data_ct_en) data_ct <= data_ct + 1;
            if (read_ct_clr) read_ct <= 0;
            else if(read_ct_en) read_ct <= read_ct + 1;
            if(ack_need_clr) ACK_needed <= 0;
            else if(ack_need_set) ACK_needed <= 1;
            if(ack_rcv_clr) ACK_received <= 0;
            else if(ack_rcv_set) ACK_received <= 1;
            if(clr_ack_frame_addr) ack_frame_addr <= 0;
            else if(set_ack_frame_addr) ack_frame_addr <= ack_frame_addr_next;
            if(ftype_clr) frame_type <= 0;
            else if(ftype_set) frame_type <= frame_type_next;
            if(rerrcount_en)rerrcount <= rerrcount + 1;
            else if (rerrcount_clr) rerrcount <= 0;
        end


    always_comb begin
        //default values
        next = IDLE;
        ack_need_clr = 0;
        ack_need_set = 0;
        ack_rcv_set = 0;
        ftype_set = 0;
        ftype_clr = 0;
        read_en = 0;
        write_en = 0;
        rerrcount_en = 0;
        rerrcount_clr = 0;
        valid_cardet = 0;
        rvalid = 0;
        read_type = 0;
        read_dest_addr = 0;
        data_ct_en = 0;
        read_ct_en = 0;
        data_ct_clr = 0;
        read_ct_clr = 0;
        crc_enb = 0;
        crc_clr = 0;
        crc_rcv = 0;
        write_address_next = write_address;
        read_address_next = read_address;
        ack_frame_addr_next =  ack_frame_addr; 
        frame_type_next = frame_type;
        set_ack_frame_addr = 0;
        clr_ack_frame_addr = 0;
        
        case (state)
            //clear all parameters
            IDLE: begin
                clr_ack_frame_addr = 1;
                read_address_next = 0;
                write_address_next = 0;
                ftype_clr = 1;
                crc_clr = 1;
                if(ack_sent) ack_need_clr = 1;
                if(valid && cardet) //first valid byte will be dest addr
                    if(data_rcvr == MAC || data_rcvr == 8'h2a) begin
                        valid_cardet = 1;
                        write_en = 1;
                        data_ct_en = 1;
                        write_address_next = write_address + 1;
                        next = WRITE_SAMPLE;
                        end
                    else begin
                        write_address_next = 0;
                        next = IDLE;
                        end
                else
                    next = IDLE;
            end

            //write mx rcvr bytes into bram
            WRITE_SAMPLE: begin
                valid_cardet = 1;
                if(valid) begin
                    if(data_ct == 1)begin
                        ack_frame_addr_next = data_rcvr;
                        set_ack_frame_addr = 1;
                    end
                    //write into bram
                    write_en = 1;
                    data_ct_en = 1;
                    if(data_ct == 2)begin
                        ftype_set = 1;
                        frame_type_next = data_rcvr;
                    end
                    write_address_next = write_address + 1;
                end else next = WRITE_SAMPLE;
                if(!cardet)begin
                    next = READ;
                    if(frame_type == 8'h32) ack_need_set = 1; 
                    if(frame_type == 8'h33) ack_rcv_set = 1;
                end else next = WRITE_SAMPLE;
            end


            //read out bram data into uart transmitter and check the frame type
            READ: begin
                valid_cardet = 1;
                rvalid = 1;
                if(ack_sent) ack_need_clr = 1;
                if(rrdy) begin
                    read_en = 1;
                    crc_enb = 1;
                    read_address_next = read_address + 1;
                    read_ct_en = 1;
                end else next = READ;          
                //type 1. stop reading 1 byte ahead to prevent writing out crc to terminal
                if(frame_type == 8'h31) begin
                    if(data_ct-1 == read_ct)begin
                        next = READ_CRC;
                        data_ct_clr = 1;
                        read_ct_clr = 1;
                        crc_rcv = 1;
                    end else next = READ;
                end
                //done reading all the data out to the uart?
                if(data_ct == read_ct) begin
                    rvalid = 0;
                    if(frame_type != 8'h30) next = READ_CRC; //check crc
                    else next = IDLE;
                    data_ct_clr = 1;
                    read_ct_clr = 1;
                    read_address_next = 0;
                    write_address_next = 0;
                end else
                    next = READ;
            end
            
            //determine if a bad checksum was received
            READ_CRC: begin
                valid_cardet = 1;
                rvalid = 1;
                if(rrdy) begin
                    if(crc_out != 0) rerrcount_en = 1;
                    crc_rcv = 1;
                    next = IDLE;
                end 
                else next = READ_CRC;  
            end         
        endcase
    end
endmodule
