

module uart_rxd_sctb();
    parameter CLK_PD = 10;
    parameter BAUD_RATE = 9600;
    
    localparam BITPD_NS = 1_000_000_000 / BAUD_RATE;
    
    logic clk, rst, rxd, rdy, valid, ferr, oerr; logic [7:0] data;
    int errcount = 0;
    
    uart_rxd #(.BAUD_RATE(BAUD_RATE)) U_DUV(.clk, .rst, .rxd, .rdy, .valid, .ferr, .oerr, .data);
    
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
    
    task check_errors(ferr, exp_ferr, oerr, exp_oerr, valid, exp_valid);
        if (ferr != exp_ferr) begin
            $display("%t error: expected ferr=%h actual ferr=%h",
                      $time, exp_ferr, ferr);
            errcount++;
        end
        if (oerr != exp_oerr) begin
            $display("%t error: expected oerr=%h actual oerr=%h",
                      $time, exp_oerr, oerr);
            errcount++;
        end
        if (valid != exp_valid) begin
            $display("%t error: expected valid=%h actual valid=%h",
                      $time, exp_valid, valid);
            errcount++;
        end
    endtask:check_errors
    
    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors
    
    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        check_errors(ferr, 0, oerr, 0, valid, 0);
    endtask: reset_duv
    
    task transmit_byte(logic [7:0] txd);
        rxd = 1'b0;
        #BITPD_NS;
        for (int i = 0; i < 8; i = i + 1) begin
            rxd = txd[i];
            #BITPD_NS;
        end
        rxd = 1'b1;
        #BITPD_NS;
    endtask:transmit_byte
    
    task transmit_ferr(logic [7:0] txd);
        rxd = 1'b0;
        #BITPD_NS;
        for (int i = 0; i < 8; i = i + 1) begin
            rxd = txd[i];
            #BITPD_NS;
        end
        rxd = 1'b0;
        #BITPD_NS;
    endtask:transmit_ferr
    
    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        rdy = 0;
        @(posedge clk);
        transmit_byte(8'b01010101);
        check_data(data, 8'b01010101); //send one byte and check that it was recieved
        transmit_ferr(8'b00110011);
        check_data(data, 8'b00110011); //send a second byte with no separation, rdy, and a framing error
        check_errors(ferr, 1, oerr, 1, valid, 1); //should have both errors high now
        rdy = 1; //set rdy high to clear oerr
        rxd = 1;
        #(BITPD_NS*2); //wait a bit
        rdy = 0;
        transmit_byte(8'b00001111); //transmit valid byte
        check_data(data, 8'b00001111);
        check_errors(ferr, 0, oerr, 0, valid, 1); //should have no errors and valid
        report_errors;
        $stop;
    end
    
endmodule
