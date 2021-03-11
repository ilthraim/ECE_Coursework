//-----------------------------------------------------------------------------
// Module Name   : uart_xmit_sctb
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Self-checking testbench for UART transmitter
//-----------------------------------------------------------------------------

module manchester_xmit_sctb (
    input logic clk, rdy, txd, txen,
    output logic rst,
    output logic [7:0] data,
    output logic valid
    );

    parameter CLOCK_PD = 10;
    parameter BAUD_RATE = 9600;
    parameter IDLE_BITS = 2;
    
    localparam BITPD_NS = 1_000_000_000 / BAUD_RATE;  // bit period in ns

    logic [15:0] flip;
    int errcount = 0;

    // tasks for common functions including checking

    task check( txd, exp_txd, rdy, exp_rdy, txen, exp_txen);
        if (txd != exp_txd) begin
             $display("%t error: expected txd=%h actual txd=%h",
                      $time, exp_txd, txd);
             errcount++;
        end else $display("test passed at time %t", $time);
        if (rdy != exp_rdy) begin
            $display("%t error: expected rdy=%h actual rdy=%h",
                     $time, exp_rdy, rdy);
             errcount++;
        end else $display("test passed at time %t", $time);
        if (txen != exp_txen) begin
            $display("%t error: expected txen=%h actual txen=%h",
                     $time, exp_txen, txen);
             errcount++;
        end else $display("test passed at time %t", $time);
    endtask: check

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors

    // transaction tasks

    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        check(txd, 1, rdy, 1, txen, 0);
    endtask: reset_duv

    task transmit(logic [7:0] d, int num_bytes);
        // transfer data via ready-valid
        data = d;
        flip = {~d[7],d[7],~d[6],d[6],~d[5],d[5],~d[4],d[4],~d[3],d[3],~d[2],d[2],~d[1],d[1],~d[0],d[0]};
        valid = 1;
        do begin
           @(posedge clk);
        end while (rdy == 0); //wait for ready to go high
        #1
        while (rdy == 1);
        # (BITPD_NS/4);  // delay to middle of bit period
        for (int j = 0; j < num_bytes; j++) begin
            if (j == num_bytes - 1) valid = 0;
            for (int i=0; i < 15; i++) begin
                check(txd, flip[i], rdy, 0, txen, 1);
                # (BITPD_NS/2);
            end
            check(txd, flip[15], rdy, 1, txen, 1);
            # (BITPD_NS/2);
        end
        # (BITPD_NS);
        check(txd, 1, rdy, 0, txen, 1); // check end stuff
    endtask


    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;

        // call transaction tasks here
        transmit(8'h55, 1);
        # (2 * BITPD_NS);
        transmit(8'h64, 6);
        report_errors;
        $stop;  // suspend simulation (use $finish to exit)
    end

endmodule