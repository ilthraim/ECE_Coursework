
module xmit_top_tb();
    parameter CLK_PD = 10;
    parameter BAUD_RATE = 9600;
    parameter BIT_RATE = 50000;
    localparam BITPD_NS = 1_000_000_000 / BAUD_RATE;
    localparam BITPD_NS_MX = 1_000_000_000 / BIT_RATE;
    logic clk, rst, rxd, a_rxd,cfgclk,cfgdat, txd, a_txd,rcv_led,backoff,crc_clr,crc_enb; logic [7:0] mac;
    logic[1:0] ftype_a;
    logic nc, oerr, uart_txd, uart_rdy, uart_valid, tx_rdy, tx_valid, tx_oerr, txd2l, sel,failsafe_1,failsafe_2;
    logic [7:0] rcvr_data, tx_data,crc_data,crc_out;
    logic [7:0] random_byte, last_byte;
    wimpfi_top U_DUV(.clk, .rst, .rxd, .a_rxd,.ftype_a, .mac, .txd, .cfgdat, .a_txd, .cfgclk, .rcv_led,.backoff,.failsafe(failsafe_1));
    wimpfi_top U_DUV_2(.clk, .rst, .rxd(txd), .a_rxd(0), .ftype_a(0), .mac(8'h4F), .txd(txd2), .a_txd(uart_txd),.failsafe(failsafe_2));
    uart_rxd U_RCVR(.clk, .rst, .rxd(uart_txd), .rdy(uart_rdy), .valid(uart_valid), .data(rcvr_data), .oerr);
    uart_rxd U_TXRCVR(.clk, .rst, .rxd(a_txd), .rdy(tx_rdy), .valid(uart_valid), .data(rcvr_data), .oerr(tx_oerr));
    crc_lookup U_CRC (.clk, .rst, .clr(crc_clr), .enb(crc_enb), .data(crc_data), .crc(crc_out));
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end

    int errcount = 0;

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors

    
    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
    endtask: reset_duv
    
    //UART INPUT TO TRANSMIT===========================================
    task transmit_byte(input logic [7:0] txd);
        a_rxd = 0;
        #BITPD_NS;
        for (int i = 0; i < 8; i = i + 1) begin
            a_rxd = txd[i];
            #BITPD_NS;
        end
        a_rxd = 1;
        #BITPD_NS;
    endtask:transmit_byte
    //UART INPUT TO TRANSMIT===========================================
    
    //RCVR TASKS==================================================================
    task rcv_bit(input logic d);
        rxd = d;
        failsafe_1 = 0;
        failsafe_2 = 0;
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
    
    task check_rcvr(input logic [7:0] data, input logic [7:0] exp_data);
        if (data != exp_data) begin
            $display("%t error: expected rcvd=%h actual rcvd=%h",
                      $time, exp_data, data);
            errcount++;
        end
    endtask:check_rcvr
    
    task send_zero(input int length);
        logic [7:0] byte_array [31:0];
        transmit_byte(8'h4F);
        transmit_byte(8'h5A);
        transmit_byte(8'h30);

        random_byte = $urandom();
        for (int i = 0; i < length; i = i + 1) begin
            byte_array[i] = random_byte;
            transmit_byte(random_byte);
            random_byte = $urandom();
        end
        transmit_byte(8'h04);
        

        mxrcv_byte(8'h4F);
        mxrcv_byte(8'h5A);
        mxrcv_byte(8'h30);
        for (int i = 0; i < length; i = i + 1) begin
            mxrcv_byte(byte_array[i]);
        end
    endtask: send_zero
    
    task send_zero_bc(input int length);
        logic [7:0] byte_array [31:0];
        transmit_byte(8'h2A);
        transmit_byte(8'h5A);
        transmit_byte(8'h30);

        random_byte = $urandom();
        for (int i = 0; i < length; i = i + 1) begin
            byte_array[i] = random_byte;
            transmit_byte(random_byte);
            random_byte = $urandom();
        end
        transmit_byte(8'h04);
        

        mxrcv_byte(8'h2A);
        mxrcv_byte(8'h5A);
        mxrcv_byte(8'h30);
        for (int i = 0; i < length; i = i + 1) begin
            mxrcv_byte(byte_array[i]);
        end
    endtask: send_zero_bc
    
    task send_one(input int length);
        logic [7:0] byte_array [31:0];
        transmit_byte(8'h4F);
        transmit_byte(8'h5A);
        transmit_byte(8'h31);

        random_byte = $urandom();
        for (int i = 0; i < length; i = i + 1) begin
            byte_array[i] = random_byte;
            transmit_byte(random_byte);
            random_byte = $urandom();
        end
        transmit_byte(8'h04);
        
        mxrcv_byte(8'h4F);
        mxrcv_byte(8'h5A);
        mxrcv_byte(8'h31);
        for (int i = 0; i < length; i = i + 1) begin
            mxrcv_byte(byte_array[i]);
        end
        mxrcv_byte(8'h21); //crc status
    endtask:send_one
    
    task send_one_bad_crc(input int length);
        logic [7:0] byte_array [31:0];
        transmit_byte(8'h4F);
        transmit_byte(8'h5A);
        transmit_byte(8'h31);

        random_byte = $urandom();
        for (int i = 0; i < length; i = i + 1) begin
            byte_array[i] = random_byte;
            transmit_byte(random_byte); 
            random_byte = $urandom();
        end
        transmit_byte(8'h04);
        
        mxrcv_byte(8'h4F);
        mxrcv_byte(8'h5A);
        mxrcv_byte(8'h31);
        crc_enb = 0;
        @(posedge clk);
        for (int i = 0; i < length; i = i + 1) begin //error: bytes have been dropped from transmission and crc only gets some of the bytes
            crc_data = byte_array[i];
            crc_enb = 1;
            @(posedge clk);
            crc_enb = 0;
            mxrcv_byte(byte_array[i]);
        end
        mxrcv_byte(8'h21); //check crc
    endtask:send_one_bad_crc
    
     task send_one_bc(input int length);
        logic [7:0] byte_array [31:0];
        transmit_byte(8'h2A);
        transmit_byte(8'h5A);
        transmit_byte(8'h31);

        random_byte = $urandom();
        for (int i = 0; i < length; i = i + 1) begin
            byte_array[i] = random_byte;
            transmit_byte(random_byte);
            random_byte = $urandom();
        end
        transmit_byte(8'h04);
        
        mxrcv_byte(8'h4F);
        mxrcv_byte(8'h5A);
        mxrcv_byte(8'h31);
        for (int i = 0; i < length; i = i + 1) begin
            mxrcv_byte(byte_array[i]);
        end
        mxrcv_byte(8'h21);
    endtask:send_one_bc
    
    task send_zero_wa(input int length);
        logic [7:0] byte_array [31:0];
        transmit_byte(8'hCC);
        transmit_byte(8'h5A);
        transmit_byte(8'h30);

        random_byte = $urandom();
        for (int i = 0; i < length; i = i + 1) begin
            byte_array[i] = random_byte;
            transmit_byte(random_byte);
            random_byte = $urandom();
        end
        transmit_byte(8'h04);
        

        mxrcv_byte(8'h2A);
        mxrcv_byte(8'h5A);
        mxrcv_byte(8'h30);
        for (int i = 0; i < length; i = i + 1) begin
            mxrcv_byte(byte_array[i]);
        end
    endtask: send_zero_wa
    
    task send_two(input int length);
        logic [7:0] byte_array [31:0];
        transmit_byte(8'h4F);
        transmit_byte(8'h5A);
        transmit_byte(8'h32);

        random_byte = $urandom();
        for (int i = 0; i < length; i = i + 1) begin
            byte_array[i] = random_byte;
            transmit_byte(random_byte);
            random_byte = $urandom();
        end
        transmit_byte(8'h04);
        

        mxrcv_byte(8'h4F);
        mxrcv_byte(8'h5A);
        mxrcv_byte(8'h32);
        for (int i = 0; i < length; i = i + 1) begin
            mxrcv_byte(byte_array[i]);
        end
        
        txrcv_byte(8'h5A);
        txrcv_byte(8'h4F);
        txrcv_byte(8'h32);
    endtask: send_two
    
    task send_two_ack(input int length);
        logic [7:0] byte_array [31:0];
        sel = 0;
        transmit_byte(8'h4F);
        transmit_byte(8'h5A);
        transmit_byte(8'h32);

        random_byte = $urandom();
        for (int i = 0; i < length; i = i + 1) begin
            byte_array[i] = random_byte;
            transmit_byte(random_byte);
            random_byte = $urandom();
        end
        transmit_byte(8'h04);
        
        #15000000;
        sel = 0;

        mxrcv_byte(8'h4F);
        mxrcv_byte(8'h5A);
        mxrcv_byte(8'h32);
        for (int i = 0; i < length; i = i + 1) begin
            mxrcv_byte(byte_array[i]);
        end
        
        txrcv_byte(8'h5A);
        txrcv_byte(8'h4F);
        txrcv_byte(8'h32);
    endtask: send_two_ack
    
    task mxrcv_byte(input logic [7:0] rcv_byte);
        uart_rdy = 1;
        while(!uart_valid) @(posedge clk);
        check_rcvr(rcvr_data, rcv_byte);
        uart_rdy = 0;
        #(CLK_PD);
    endtask: mxrcv_byte
    
    task txrcv_byte(input logic [7:0] rcv_byte);
        tx_rdy = 1;
        while(!tx_valid) @(posedge clk);
        check_rcvr(tx_data, rcv_byte);
        tx_rdy = 0;
        #(CLK_PD);
    endtask: txrcv_byte
    
    task failsafe_test();
        for (int i = 0; i < 550; i = i + 1) begin
            failsafe_1 = 1;
        end
    endtask: failsafe_test
    
    assign rxd = sel ? txd2 : 1'b1;
    
    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        backoff = 0;
        sel = 1;
        //rdy = 0;
        @(posedge clk);
        ftype_a = 2'b11; //has no current use in sim. Used for debugging in hardware
        mac = 8'h5A; //our station's src addr. broadcast is 2A
        send_one_bad_crc(3);
//        send_two(5);
//        report_errors;
        $stop;
    end
    
endmodule