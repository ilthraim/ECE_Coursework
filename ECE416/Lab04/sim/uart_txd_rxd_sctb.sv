module uart_txd_rxd_sctb();

    parameter CLK_PD = 10;
    parameter BAUD_RATE = 9600;
    
    localparam BITPD_NS = 1_000_000_000 / BAUD_RATE;
    
    
    logic clk, rst, rxd, txd, rdy_xmit, rdy_rxd, valid_xmit, valid_rxd, ferr, oerr; logic [7:0] data_in, data_out;
    int errcount = 0;
    
    assign rxd = txd;
    
    uart_xmit #(.BAUD_RATE(BAUD_RATE)) U_DUV1(.clk100MHz(clk), .rst, .valid(valid_xmit), .data(data_in), .txd, .rdy(rdy_xmit));
    uart_rxd #(.BAUD_RATE(BAUD_RATE)) U_DUV2(.clk, .rst, .rxd, .rdy(rdy_rxd), .valid(valid_rxd), .ferr, .oerr, .data(data_out));
    
    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end

    task check_data(logic [7:0] data, logic [7:0] exp_data);
        if (data != exp_data) begin
            $display("%t error: expected data=%h actual data=%h",
                      $time, exp_data, data);
            errcount++;
        end
    endtask:check_data
    
    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors
    
    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
    endtask: reset_duv

    task send_bytes(int n);
        logic [7:0] random_byte, this_byte;
        data_in = $urandom();
        valid_xmit = 1;
        for (int i = 0; i < n; i = i + 1) begin
            this_byte = data_in;
            #(BITPD_NS*5);
            random_byte = $urandom();
            data_in = random_byte;
            #(BITPD_NS*5);
            check_data(data_out, this_byte);
        end
    endtask: send_bytes

    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        @(posedge clk);
        send_bytes(2);
        report_errors;
        $stop;
    end
endmodule
