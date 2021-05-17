module rcv_controller #(parameter PREAMBLE_LENGTH = 1)(
    input logic clk, rst, valid, cardet, rrdy,
    input logic [7:0] MAC, data_bram,fcs, data_rcvr,
    output logic write_en, read_en, ACK_needed, ACK_received, rvalid,
    output logic [7:0] rerrcount,
    output logic [8:0] write_address, read_address
);

logic empty, rerrcount_en, read_type, read_dest_addr,data_ct_clr,data_ct_en,read_ct_clr,read_ct_en;
logic [8:0] read_address_next, write_address_next,data_ct,read_ct;

typedef enum logic [1:0] {IDLE, WRITE_SAMPLE, CHECK_TYPE, READ} states_t;
states_t state, next;

//assign empty = (write_address == read_address);

    always_ff @(posedge clk) begin
        if (rst) begin
            write_address <= 0;
            read_address <= 0;
            rerrcount <= 0;
            data_ct <= 0;
            read_ct = 0;
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
        read_en = 0;
        write_en = 0;
        rerrcount_en = 0;
        ACK_needed = 0;
        ACK_received = 0;
        rvalid = 0;
        read_type = 0;
        read_dest_addr = 0;
        data_ct_en = 0;
        read_ct_en = 0;
        data_ct_clr = 0;
        read_ct_clr = 0;
        write_address_next = write_address;
        read_address_next = read_address;
        case (state)
            IDLE: begin
                read_address_next = 0;
                write_address_next = 0;
                
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
                    //write into bram
                     write_en = 1;
                     data_ct_en = 1;
                     write_address_next = write_address + 1;
                end
                else next = WRITE_SAMPLE;
                
                
                if(!cardet) next = READ;
                else next = WRITE_SAMPLE;
//                if(cardet && valid)
//                    next = WRITE_SAMPLE;
//                else
//                    next = CHECK_TYPE;
            end

            CHECK_TYPE: begin

                read_type = 1;
                read_en = 1;

                //read type
                case (data_bram)
                    //type 0
                    8'd0: begin
                        next = READ;
                    end
                    //type 1
                    8'd1: begin
                        if(fcs == 0)
                            next = READ;
                        else begin
                            rerrcount_en = 1;
                            next = IDLE;
                        end

                    end
                    //type 2
                    8'd2: begin
                        read_dest_addr = 1;
                        read_en = 1;

                        if(data_bram == 8'h2a);
                        //do nothing
                        else
                            ACK_needed = 1;

                        //regardless of previous if statement, check fcs
                        if(fcs == 0)
                            next = READ;
                        else begin
                            rerrcount_en = 1;
                            next = IDLE;
                        end

                    end
                    //type 3
                    8'd3: begin
                        if(fcs == 0)
                            ACK_received = 1;
                        else
                            rerrcount_en = 1;

                        next = IDLE;

                    end

                    default:begin
                        next = IDLE;
                    end

                endcase

            end

            READ: begin
                rvalid = 1;
                if(rrdy) begin
                    read_en = 1;
                    read_address_next = read_address + 1;
                    read_ct_en = 1;
                end
                else next = READ;
                //done reading all the data out to the uart?
                //SET UP FRAME CHECK FOR ACK FRAME
                if(data_ct == read_ct) begin
                    next = IDLE;
                    data_ct_clr = 0;
                    read_ct_clr = 0;
                    read_address_next = 0;
                    write_address_next = 0;
                end else
                    next = READ;
            end

        endcase
    end


endmodule
