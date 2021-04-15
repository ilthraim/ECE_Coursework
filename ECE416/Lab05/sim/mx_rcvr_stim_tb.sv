
module mx_rcvr_stim_tb();

    logic clk, rst, rxd, valid, cardet, error, bitclk;
    logic [7:0] data;
    
    mx_rcvr #(.BIT_RATE(50000)) U_RCVR (.clk, .rst, .rxd, .valid, .cardet, .error, .data);
    
    parameter CLK_PD = 10;
    parameter BIT_DELAY = 20000;

    always begin
        clk = 1'b0; #(CLK_PD/2);
        clk = 1'b1; #(CLK_PD/2);
    end
    always begin
        bitclk = 1'b0; #(BIT_DELAY/2);
        bitclk = 1'b1; #(BIT_DELAY/2);
    end

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
    
    task send_error;
        rxd = 1;
        #(BIT_DELAY);
    endtask: send_error
    
    task send_one_byte;
        for (int i = 0; i < 8; i = i + 1)
            send_one;
    endtask: send_one_byte
    
    task send_byte_error;
        send_one;
        send_one;
        send_one;
        send_error;
        send_one;
        send_one;
        send_one;
        send_one;
    endtask: send_byte_error
    
    task send_preamble;
        for (int i = 0; i < 4; i = i + 1) begin
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

    initial begin
    rxd = 1;
    rst = 1;
    @(posedge clk) #1;
        rst = 0;
    @(posedge clk);
        send_preamble;
        send_SFD;
        send_one_byte;
        send_byte_error;
    #(BIT_DELAY*2);
    $stop;
    end

endmodule
