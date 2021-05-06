module rcv_controller #(parameter PREAMBLE_LENGTH = 1)(
    input logic clk, rst, valid, cardet, rrdy,
    input logic [7:0] MAC, data_bram,fcs,
    output logic write_en, read_en, ACK_needed, ACK_received, rvalid,
    output logic [7:0] rerrcount,
    output logic [31:0] write_address, read_address
);

logic empty, rerrcount_en, read_type, read_dest_addr;
typedef enum logic [1:0] {IDLE, WRITE_SAMPLE, CHECK_TYPE, READ} states_t;
states_t state, next;

assign empty = (write_address == read_address);

    always_ff @(posedge clk) begin
        if (rst) begin
            write_address <= 0;
            read_address <= 0;
            rerrcount <= 0;
            state <= IDLE;
        end
        else
            state <= next;


        //increment the write address when in the WRITE_SAMPLE state
        if(write_en)
            write_address <= write_address + 1;
        //increment the read address in the READ state (could be an issue for type2 frame being off by 1 byte)
        if(read_en)
            read_address <= read_address + 1;
        //increment the error counter if fcs isn't 0
        if(rerrcount_en)
            rerrcount <= rerrcount + 1;
        //change read address to the type position in the frame
        if(read_type)
            read_address <= PREAMBLE_LENGTH + 3;
        //change read address to the destination address position in the frame
        if(read_dest_addr)
            read_address <= PREAMBLE_LENGTH + 1;
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

        case (state)
            IDLE: begin

                if(valid && cardet)
                    if(data_bram == MAC || data_bram == 8'h2a)
                        next = WRITE_SAMPLE;
                    else
                        next = IDLE;
                else
                    next = IDLE;
            end

            WRITE_SAMPLE: begin

                write_en = 1;

                if(cardet && valid)
                    next = WRITE_SAMPLE;
                else
                    next = CHECK_TYPE;
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
                read_en = 1;
                //if bram is empty and rrdy
                if(!empty && rrdy)
                    next = READ;
                else
                    next = IDLE;
            end

        endcase
    end


endmodule
