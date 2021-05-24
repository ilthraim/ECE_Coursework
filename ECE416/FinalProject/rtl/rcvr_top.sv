//-----------------------------------------------------------------------------
// Module Name   : rcvr_top
// Project       : wimpFi
//-----------------------------------------------------------------------------
// Author        : Zachary Martin
// Created       : May 2021
//-----------------------------------------------------------------------------
// Description   : Top level module integrating rcvr FSM, manchester receiver,
//crc lookup table, and block ram.
//-----------------------------------------------------------------------------
module rcvr_top(input logic clk, rst, ack_sent,ack_rcv_clr, rxd, rrdy, [7:0] MAC, output logic cardet,valid_cardet, ACK_needed, ACK_received, rvalid,[3:0]rerrcnt, [7:0] ack_frame_addr, rcvr_data);
parameter BIT_RATE = 50000;


logic [8:0] write_address, read_address;
logic[7:0] data,crc_out,rdata;
logic valid, read_en, error, crc_xmit, crc_rcv;

assign rcvr_data = crc_rcv ? (crc_out != 0 ? "!" : 8'h2B) : rdata; //note: 2B = "+". Used for displaying a good or bad CRC

//FSM
rcv_controller rcvr_top_fsm (.clk, .rst, .valid, .cardet, .ack_sent,.ack_rcv_clr, .rrdy, .MAC, .data_rcvr(data), .crc_enb, .crc_clr, .crc_rcv, .data_bram(rdata),.fcs(crc),.write_en, .read_en, .ACK_needed, .ACK_received, .rvalid,
.rerrcount(rerrcnt),.write_address, .read_address,.ack_frame_addr,.valid_cardet,.crc_out);

//BRAM
bram_dp rcvr_BRAM (.clka(clk),.wea(write_en),.addra(write_address),.dina(data),.clkb(clk),.addrb(read_address),.doutb(rdata),.ena(1'b1),.enb(1'b1));

//Manchester Receiver
mx_rcvr #(.BIT_RATE(BIT_RATE)) mx_receiver(.clk, .rst, .rxd,.valid, .cardet, .error, .data);

//CRC
crc_lookup U_CRC (.clk, .rst, .clr(crc_clr), .enb(crc_enb), .data(rdata), .crc(crc_out));

endmodule
