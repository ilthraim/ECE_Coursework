module rcv_controller #(parameter PREAMBLE_LENGTH = 1)(
    input logic clk, rst, valid, cardet, rrdy, ack_sent,
    input logic [7:0] MAC, data_bram,fcs, data_rcvr,
    output logic write_en, read_en, ACK_needed, ACK_received, rvalid, crc_enb, crc_clr,crc_rcv,
    output logic [7:0] rerrcount,
    output logic [8:0] write_address, read_address,ack_frame_addr
);

logic empty, rerrcount_en, read_type, read_dest_addr,data_ct_clr,data_ct_en,read_ct_clr,read_ct_en,ack_need_set,ack_need_clr,ack_rcv_set,ack_rcv_clr;
logic [8:0] read_address_next, write_address_next,data_ct,read_ct;
logic [7:0] frame_type;

typedef enum logic [2:0] {IDLE, WRITE_SAMPLE, CHECK_TYPE, READ,READ_CRC} states_t;
states_t state, next;

//assign empty = (write_address == read_address);

    always_ff @(posedge clk) begin
        if (rst) begin
            write_address <= 0;
            read_address <= 0;
            rerrcount <= 0;
            data_ct <= 0;
            read_ct <= 0;
            state <= IDLE;
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
//        //increment the write address when in the WRITE_SAMPLE state
//        if(write_en)
//            write_address <= write_address + 1;
//        //increment the read address in the READ state (could be an issue for type2 frame being off by 1 byte)
//        if(read_en)
//            read_address <= read_address + 1;
        //increment the error counter if fcs isn't 0
//        if(rerrcount_en)
//            rerrcount <= rerrcount + 1;
        //change read address to the type position in the frame
//        if(read_type)
//            read_address <= PREAMBLE_LENGTH + 3;
//        //change read address to the destination address position in the frame
//        if(read_dest_addr)
//            read_address <= PREAMBLE_LENGTH + 1;
    end


    always_comb begin
        //default values
        next = IDLE;
        ack_need_clr = 0;
        ack_need_set = 0;
        ack_rcv_set = 0;
        ack_rcv_clr = 0;
        read_en = 0;
        write_en = 0;
        rerrcount_en = 0;
//        ACK_needed = 0;
//        ACK_received = 0;
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
        case (state)
            IDLE: begin
                read_address_next = 0;
                write_address_next = 0;
                crc_clr = 1;
                if(ack_sent) ack_need_clr = 1;
                ack_need_clr = 1;
                //ack_rcv_clr = 1;
                if(valid && cardet) //first valid byte will be dest addr
                    if(data_rcvr == MAC || data_rcvr == 8'h2a) begin
                       
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

            WRITE_SAMPLE: begin
                if(valid) begin
                    if(data_ct == 1) ack_frame_addr = data_rcvr;
                    //write into bram
                     write_en = 1;
                     data_ct_en = 1;
                     if(data_ct == 2) begin
                        frame_type = data_rcvr;
                        
                     end
                     write_address_next = write_address + 1;
                end
                else next = WRITE_SAMPLE;
                
                
                if(!cardet)begin
                    next = READ;
                    if(frame_type == 8'h32) ack_need_set = 1;
                    if(frame_type == 8'h33) ack_rcv_set = 1;
                end
                else next = WRITE_SAMPLE;
//                if(cardet && valid)
//                    next = WRITE_SAMPLE;
//                else
//                    next = CHECK_TYPE;
            end

            CHECK_TYPE: begin

//                read_type = 1;
//                read_en = 1;

//                //read type
//                case (data_bram)
//                    //type 0
//                    8'd0: begin
//                        next = READ;
//                    end
//                    //type 1
//                    8'd1: begin
//                        if(fcs == 0)
//                            next = READ;
//                        else begin
//                            rerrcount_en = 1;
//                            next = IDLE;
//                        end

//                    end
//                    //type 2
//                    8'd2: begin
//                        read_dest_addr = 1;
//                        read_en = 1;

//                        if(data_bram == 8'h2a);
//                        //do nothing
//                        else
//                            ACK_needed = 1;

//                        //regardless of previous if statement, check fcs
//                        if(fcs == 0)
//                            next = READ;
//                        else begin
//                            rerrcount_en = 1;
//                            next = IDLE;
//                        end

//                    end
//                    //type 3
//                    8'd3: begin
//                        if(fcs == 0)
//                            ACK_received = 1;
//                        else
//                            rerrcount_en = 1;

//                        next = IDLE;

//                    end

//                    default:begin
//                        next = IDLE;
//                    end

//                endcase

            end

            READ: begin
                rvalid = 1;
                if(ack_sent) ack_need_clr = 1;
                if(rrdy) begin
                    read_en = 1;
                    crc_enb = 1;
                    read_address_next = read_address + 1;
                    read_ct_en = 1;
                end
                else next = READ;
                
                //type 1. stop reading 1 byte ahead to prevent writing out crc to terminal
                if(frame_type == 8'h31) begin
                    if(data_ct-1 == read_ct)begin
                        next = READ_CRC;
                        data_ct_clr = 1;
                        read_ct_clr = 1;
                        crc_rcv = 1;
                    end
                    else next = READ;
                end
                //done reading all the data out to the uart?
                //SET UP FRAME CHECK FOR ACK FRAME
                if(data_ct == read_ct) begin
                    rvalid = 0;
                    if(frame_type != 8'h30) next = READ_CRC;
                    else next = IDLE;
                    data_ct_clr = 1;
                    read_ct_clr = 1;
                    read_address_next = 0;
                    write_address_next = 0;
                end else
                    next = READ;
            end
            
            READ_CRC: begin
                rvalid = 1;
                if(rrdy) begin

                    crc_rcv = 1;
                    next = IDLE;
                end 
                else next = READ_CRC;  
            end
            
        endcase
    end


endmodule
