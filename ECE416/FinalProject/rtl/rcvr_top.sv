module rcvr_top(input logic clk, rst, rxd, rrdy, [7:0] MAC, output logic cardet, ACK_needed, ACK_received, rvalid, [7:0] rdata, rerrcnt);
parameter BIT_RATE = 50000;

//add crc
logic[7:0] data,crc;
logic valid, read_en, error;
rcv_controller rcvr_top_fsm (.clk, .rst, .valid, .cardet, .rrdy, .MAC, .data_bram(rdata),.fcs(crc),.write_en, .read_en, .ACK_needed, .ACK_received, .rvalid,
.rerrcount(rerrcnt),.write_address, .read_address);

bram_dp rcvr_BRAM (.clka(clk),.wea(write_en),.addra(write_address),.dina(data),.clkb(clk),.addrb(read_address),.doutb(rdata));


mx_rcvr #(.BIT_RATE(BIT_RATE)) mx_receiver(.clk, .rst, .rxd,.valid, .cardet, .error, .data);

endmodule
