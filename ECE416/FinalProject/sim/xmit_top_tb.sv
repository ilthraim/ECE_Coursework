
module xmit_top_tb();
    parameter CLK_PD = 10;
    parameter BAUD_RATE = 9600;
    parameter BIT_RATE = 50000;
    localparam BITPD_NS = 1_000_000_000 / BAUD_RATE;
    
    logic clk, rst, rxd, a_rxd,cfgclk,txen, txd, a_txd; logic [7:0] mac;
    logic[1:0] ftype_a;
    wimpfi_top U_DUV(
.clk, .rst, .rxd, .a_rxd,.ftype_a, .mac, .
txd, .txen, .a_txd, .cfgclk
);
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

    
    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        //rdy = 0;
        @(posedge clk);
        ftype_a = 2'b00;
        mac = 8'h44;
        transmit_byte(8'h5A); //dest addr:Z
        transmit_byte(8'h44);//src addr:D
        transmit_byte(8'h30);//src addr:D
        transmit_byte(8'h68);//data h
        transmit_byte(8'h69);//data i
        transmit_byte(8'h04); //end transmission
        $stop;
    end
    
endmodule