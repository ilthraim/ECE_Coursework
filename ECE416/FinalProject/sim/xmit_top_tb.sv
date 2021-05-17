
module xmit_top_tb();
    parameter CLK_PD = 10;
    parameter BAUD_RATE = 9600;
    parameter BIT_RATE = 50000;
    localparam BITPD_NS = 1_000_000_000 / BAUD_RATE;
    localparam BITPD_NS_MX = 1_000_000_000 / BIT_RATE;
    logic clk, rst, rxd, a_rxd,cfgclk,cfgdat, txd, a_txd; logic [7:0] mac;
    logic[1:0] ftype_a;
    wimpfi_top U_DUV(.clk, .rst, .rxd, .a_rxd,.ftype_a, .mac, .txd, .cfgdat, .a_txd, .cfgclk);
    //uart_rxd #(.BAUD_RATE(BAUD_RATE)) U_DUV(.clk, .rst, .rxd, .rdy, .valid, .ferr, .oerr, .data);
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    
   

    

    
    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
    endtask: reset_duv
    
    //UART INPUT TO TRANSMIT===========================================
    task transmit_byte(input logic [7:0] txd);
        rxd = 1'b0;
        a_rxd = 0;
        #BITPD_NS;
        for (int i = 0; i < 8; i = i + 1) begin
            a_rxd = txd[i];
            #BITPD_NS;
        end
        rxd = 1'b1;
        a_rxd = 1;
        #BITPD_NS;
    endtask:transmit_byte
    //UART INPUT TO TRANSMIT===========================================
    
    //RCVR TASKS==================================================================
    task rcv_bit(input logic d);
        rxd = d;
        #(BITPD_NS_MX/2);
        rxd = !d;
        #(BITPD_NS_MX/2);
    endtask

    task rcv_byte(input logic [7:0] data);
        $display("send_byte: %h at time %t", data, $time);
        for (int i=0; i<=7; i++) begin
            rcv_bit(data[i]);  // send lsb first
        end
    endtask
    //RCVR TASKS =====================================================================
    
    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        //rdy = 0;
        @(posedge clk);
        ftype_a = 2'b11;
        mac = 8'h5A; //our station's src addr. broadcast is 2A
        rcv_byte(8'hAA);
        rcv_byte(8'hD0);
        rcv_byte(8'h5A); //dest addr:
        rcv_byte(8'h44);//src addr:D
        rcv_byte(8'h31);//frame type: 1
        rcv_byte(8'h68);//data h
        rcv_byte(8'h69);//data i
        rcv_byte(8'h23); //crc: good for "hi" is 66
//        #(BITPD_NS*20);
//        rcv_byte(8'hAA);
//        rcv_byte(8'hD0);
//        rcv_byte(8'h5A); //dest addr:
//        rcv_byte(8'h44);//src addr:D
//        rcv_byte(8'h30);//frame type
//        rcv_byte(8'h68);//data h
//        rcv_byte(8'h69);//data i
//        transmit_byte(8'h5A); //dest addr:Z
//        transmit_byte(8'h44);//src addr:D
//        transmit_byte(8'h30);//src addr:D
//        transmit_byte(8'h68);//data h
//        transmit_byte(8'h69);//data i
//        transmit_byte(8'h04); //end transmission
//        #(BITPD_NS*40);
//        transmit_byte(8'h5A); //dest addr:Z
//        transmit_byte(8'h44);//src addr:D
//        transmit_byte(8'h30);//src addr:D
//        transmit_byte(8'h68);//data h
//        transmit_byte(8'h69);//data i
//        transmit_byte(8'h04); //end transmission
//        #(BITPD_NS*40);
//        transmit_byte(8'h5A); //dest addr:Z
//        transmit_byte(8'h44);//src addr:D
//        transmit_byte(8'h31);//src addr:D
//        transmit_byte(8'h68);//data h
//        transmit_byte(8'h69);//data i
//        transmit_byte(8'h04); //end transmission
      //  #(BITPD_NS*20);
//        rcv_byte(8'hAA);
//        rcv_byte(8'hD0);
//        rcv_byte(8'h5A); //dest addr:
//        rcv_byte(8'h44);//src addr:D
//        rcv_byte(8'h30);//frame type
//        rcv_byte(8'h79);//data y
//        rcv_byte(8'h6F);//data o
        $stop;
    end
    
endmodule