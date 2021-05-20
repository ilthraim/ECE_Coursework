module xmit_top #(parameter BIT_RATE = 50000, IDLE_BITS =2) (
    input logic clk, rst, xvalid, xsend, cardet, ACK_received, ACK_needed, [7:0] mac, ack_addr, xdata, uart_in, ftype,ack_frame_addr, 
    output logic txd,ack_sent, txen, xrdy, xbusy, [7:0] xerrcnt);

//add CRC!
    logic [8:0] write_address,read_address;
    logic[7:0] addr_xmit,ftype_xmit,preamble,SFD,crc,bram_in,data,dest_addr, xmit_data,frame_type;
    logic[2:0] data_sel;
    logic mx_valid,write_en,read_en,valid,rdy,mx_rdy,enb_out_uart,enb_out_mx, crc_xmit;
    logic crc_clr, crc_enb;
    logic [7:0] crc_out;
    assign preamble = 8'b10101010;
    assign SFD = 8'hD0;
    assign addr_xmit = ACK_needed  ?  ack_frame_addr : uart_in; 
    assign ftype_xmit = ACK_needed ?  8'h33: frame_type;
    assign crc = 8'h55;
    assign xmit_data = crc_xmit ? crc_out : data;
    localparam mx_8 = BIT_RATE*8;
    mux_3_8 #(.W(8)) xmit_mux (.d0(preamble),.d1(SFD),.d2(addr_xmit),.d3(mac),.d4(ftype_xmit),.d5(uart_in),.d6(crc),.d7(8'h00), .sel(data_sel), .y(bram_in));
    
    xmit_controller xmit_top_fsm (.clk, .rst, .xvalid, .xsend, .mx_rdy, .ACK_received, .ACK_needed, .MAC(mac), .dest_addr, .ftype(ftype_xmit), .cardet, .enb_out_uart,.enb_out_mx,.enb_out_8,
    .xrdy, .xbusy, .mx_valid, .xerrcnt, .write_en, .write_address, .read_address, .read_en, .data_select(data_sel),.uart_in, .crc_xmit, .crc_clr, .crc_en(crc_enb),.ack_frame_addr,.ack_sent,.frame_type);
    
    bram_dp xmit_BRAM (.clka(clk),.wea(write_en),.addra(write_address),.dina(bram_in),.clkb(clk),.addrb(read_address),.doutb(data),.ena(1'b1),.enb(1'b1));
     //ip_dumb xmit_BRAM (.clka(clk),.wea(write_en),.addra(write_address),.dina(bram_in),.clkb(clk),.addrb(read_address),.doutb(data),.ena(1'b1),.enb(1'b1));
    manchester_xmit #(.BIT_RATE(BIT_RATE), .IDLE_BITS(IDLE_BITS)) mx_xmit (.clk, .rst, .valid(mx_valid), .data(xmit_data),.rdy(mx_rdy), .txd, .txen);
    
    crc_lookup U_CRC (.clk, .rst, .clr(crc_clr), .enb(crc_enb), .data, .crc(crc_out));

    rate_enb #(9600) xmit_top_uart_rate  (.clk, .rst, .enb_out(enb_out_uart), .clr(1'b0));
    rate_enb #(BIT_RATE) xmit_top_mx_rate  (.clk, .rst, .enb_out(enb_out_mx), .clr(1'b0));
    rate_enb #(mx_8) xmit_top_8  (.clk, .rst, .enb_out(enb_out_8), .clr(1'b0));
endmodule