module xmit_top #(parameter BIT_RATE = 50000, IDLE_BITS =2) (
    input logic clk, rst, xvalid, xsend, cardet, ACK_received, ACK_needed, [7:0] mac, ack_addr, xdata, [1:0] dest_addr, ftype, uart_in,
    output logic txd, txen, xrdy, xbusy, [7:0] xerrcnt);

//add CRC!
    logic [8:0] write_address,read_address;
    logic[7:0] addr_xmit,ftype_xmit,preamble,SFD,crc,bram_in,data;
    logic[2:0] data_sel;
    logic mx_valid,write_en,read_en,valid,rdy,mx_rdy;
    assign preamble = 8'b10101010;
    assign SFD = 8'b00001011;
    assign addr_xmit = ACK_needed  ? ack_addr : dest_addr;
    assign ftype_xmit = ACK_needed ? ftype : 8'h33;
    
    mux_3_8 #(.W(8)) xmit_mux (.d0(preamble),.d1(SFD),.d2(addr_xmit),.d3(mac),.d4(ftype_xmit),.d5(xdata),.d6(crc),.d7(8'h00), .sel(data_sel), .y(bram_in));
    
    xmit_controller xmit_top_fsm (.clk, .rst, .xvalid, .xsend, .mx_rdy, .ACK_received, .ACK_needed, .MAC(mac), .dest_addr, .ftype, .cardet,
    .xrdy, .xbusy, .mx_valid, .xerrcnt, .write_en, .write_address, .read_address, .read_en, .data_select(data_sel));
    
    blk_mem_gen_1 xmit_BRAM (.clka(clk),.wea(write_en),.addra(write_address),.dina(bram_in),.clkb(clk),.addrb(read_address),.doutb(data));

    manchester_xmit #(.BIT_RATE(BIT_RATE), .IDLE_BITS(IDLE_BITS)) mx_xmit (.clk, .rst, .valid, .data,.rdy(mx_rdy), .txd, .txen);

endmodule