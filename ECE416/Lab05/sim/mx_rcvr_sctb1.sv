module mx_rcvr_sctb1();

    logic clk, rst, rxd, valid, cardet, error, bitclk;
    logic [7:0] data;
    
    mx_rcvr #(.BIT_RATE(50000)) U_RCVR (.clk, .rst, .rxd, .valid, .cardet, .error, .data);
    
    parameter CLK_PD = 10;
    parameter BIT_DELAY = 20000;
    int errcount = 0;
    int validcount = 0;

    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    
    always begin
        bitclk = 1'b0; #(BIT_DELAY/2);
        bitclk = 1'b1; #(BIT_DELAY/2);
    end
    
    always begin
        @(posedge clk) #1;
        if (valid) validcount = validcount + 1;
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
        
    task check_errors(valid, exp_valid, cardet, exp_cardet, error, exp_error);
        if (cardet != exp_cardet) begin
            $display("%t error: expected cardet=%h actual cardet=%h",
                      $time, exp_cardet, cardet);
            errcount++;
        end
        if (error != exp_error) begin
            $display("%t error: expected error=%h actual error=%h",
                      $time, exp_error, error);
            errcount++;
        end
        if (valid != exp_valid) begin
            $display("%t error: expected valid=%h actual valid=%h",
                      $time, exp_valid, valid);
            errcount++;
        end
    endtask:check_errors
        
    task send_one;
        rxd = 1;
        #(BIT_DELAY / 2);
        rxd = 0;
        #(BIT_DELAY / 2);
    endtask: send_one
    
    task send_zero;
        rxd = 0;
        #(BIT_DELAY / 2);
        rxd = 1;
        #(BIT_DELAY / 2);
    endtask: send_zero
    
    task send_preamble(input int l);
        for (int i = 0; i < (l/2); i = i + 1) begin
            send_one;
            send_zero;
        end
    endtask: send_preamble
        
    task send_SFD;
        send_zero;
        send_zero;
        send_zero;
        send_zero;
        send_one;
        send_zero;
        send_one;
        send_one;
    endtask: send_SFD
    
    task send_bytes(input int n);
        logic [7:0] random_byte;
        logic curr_bit;
        curr_bit = $urandom();
        for (int i = 0; i < n; i = i + 1) begin
            for (int j = 0; j < 8; j = j + 1) begin
                if (curr_bit) send_one;
                else send_zero;
                random_byte = {curr_bit, random_byte[6:0]};
                curr_bit = $urandom();
            end
            check_data(data, random_byte);
            check_errors(validcount, i + 1, cardet, 1, error, 0);
        end
    endtask: send_bytes
    
    task send_error;
        rxd = 0;
        #(BIT_DELAY);
    endtask: send_error
    
    task send_byte_error;
        send_one;
        send_one;
        send_one;
        send_error;
        send_one;
        send_one;
        send_one;
        send_one;
        check_errors(validcount, 2, cardet, 0, error, 1);
    endtask: send_byte_error
    
    task send_short_byte;
        send_one;
        send_one;
        send_one;
        rxd = 1;
        #(BIT_DELAY * 2);
        check_errors(validcount, 0, cardet, 0, error, 1);
    endtask: send_short_byte;
    
    task send_noise(input int n);
        logic curr_bit;
        curr_bit = $urandom();
        for (int i = 0; i < n; i = i + 1) begin
            rxd = curr_bit;
            #(BIT_DELAY / 16);
            curr_bit = $urandom();
        end
    endtask: send_noise
    
    task check_a;
        #(BIT_DELAY*4);
        @(posedge clk);
        validcount = 0;
        send_preamble(16);
        send_SFD;
        send_bytes(1);
        rxd = 1;
        #(BIT_DELAY*2);
    endtask: check_a;
     
    task check_b;
        #(BIT_DELAY*4);
        @(posedge clk);
        validcount = 0;
        send_preamble(16);
        send_SFD;
        send_bytes(3);
        rxd = 1;
        #(BIT_DELAY*2);
    endtask: check_b;
        
    task check_c;
        #(BIT_DELAY*4);
        @(posedge clk);
        validcount = 0;
        send_noise(1600);
        send_preamble(16);
        send_SFD;
        send_bytes(3);
        rxd = 1;
        #(BIT_DELAY*2);
        send_noise(1600);
    endtask: check_c;
    
    task check_d;
        #(BIT_DELAY*4);
        @(posedge clk);
        validcount = 0;
        send_preamble(16);
        send_SFD;
        send_bytes(2);
        send_byte_error;
        rxd = 1;
        #(BIT_DELAY*2);
    endtask: check_d;
        
    task check_e;
        #(BIT_DELAY*4);
        @(posedge clk);
        validcount = 0;
        send_preamble(16);
        send_SFD;
        send_short_byte;
        rxd = 1;
        #(BIT_DELAY*2);
    endtask: check_e;
     
    initial begin
        rxd = 1;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        check_e;
        report_errors;
        $stop;
    end
    
endmodule
