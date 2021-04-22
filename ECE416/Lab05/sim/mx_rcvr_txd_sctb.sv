module mx_rcvr_txd_sctb();

    logic clk, rst, rxd_rcvr, valid_rcvr, cardet, error, bitclk, valid_txd, txd, txen, rdy;
    logic [7:0] data_out, data_in;
    logic begin_send;
    logic [7:0] random_byte;
    logic [7:0] last_byte;

    mx_rcvr #(.BIT_RATE(50000)) U_RCVR (.clk, .rst, .rxd(rxd_rcvr), .valid(valid_rcvr), .cardet, .error, .data(data_out));
    manchester_xmit #(49500) DUV (.clk, .rst, .valid(valid_txd), .data(data_in), .rdy, .txd, .txen);
    parameter CLK_PD = 10;
    parameter BIT_DELAY = 20000;
    parameter PREAMBLE = 16'b0101010101010101;
    parameter SFD = 8'b11010000;
    
    int errcount = 0;
    assign rxd_rcvr = txd;
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors

    task check_data(input logic [7:0] data, input logic [7:0] exp_data);
        if (data != exp_data) begin
            $display("%t error: expected data=%h actual data=%h",
                      $time, exp_data, data);
            errcount++;
        end
    endtask:check_data

    task send_byte(input logic [7:0] txd_byte);
        begin_send = 1;
        @(posedge clk);
        valid_txd = 1;
        data_in = txd_byte;
        while (!rdy) #CLK_PD;
        @(posedge clk) #CLK_PD;
        valid_txd = 0;
        begin_send = 0;
    endtask: send_byte
    
    task rcv_byte(input logic [7:0] rcv_byte);
        @(posedge clk);
        while(!valid_rcvr) @(posedge clk);
        check_data(data_out, rcv_byte);
    endtask: rcv_byte
    
    task send_bytes(input int n);
        
        random_byte = $urandom();
        last_byte = random_byte;
        //send_byte(random_byte);
        for (int i = 0; i < n; i = i + 1) begin
            if (i == 0) begin
                send_byte(random_byte);
            end else begin
                fork
                    send_byte(random_byte);
                    rcv_byte(last_byte);
                join
                
            end
            last_byte = random_byte;
                random_byte = $urandom();
        end
    endtask: send_bytes
    
     initial begin
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        send_byte(PREAMBLE[7:0]);
        send_byte(PREAMBLE[15:8]);
        send_byte(SFD);
        send_bytes(255);
        report_errors;
        $stop;
    end

endmodule
