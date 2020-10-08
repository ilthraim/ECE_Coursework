`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 08:06:20 AM
// Design Name: 
// Module Name: fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fsm(input logic clk, rst, col_done, sclk_done,
            output logic sclk_enb, col_enb, abc_enb, blank, lat);
    
    logic wait_enb, wait_done;
    
    wait_timer U_WAIT(.clk, .rst, .enb(wait_enb), .done(wait_done));
    
    typedef enum logic [3:0] {
    LOAD, BLANK, INC_REG, WAIT, LAT} states_t;
    
    states_t state, next;
    
    always_ff @(posedge clk)
        begin
            if (rst)
                state <= LOAD;
            else
                state <= next;
        end
        
    always_comb
        begin
            sclk_enb = 0;
            blank = 1;
            lat = 0;
            wait_enb = 0;
            abc_enb = 0;
            next = LOAD;
            
            case(state)
                LOAD:
                    begin
                        blank = 0;
                        sclk_enb = 1;
                        if (col_done) next = BLANK;
                        else next = LOAD;
                    end
                BLANK:
                    begin
                        blank = 1;
                        wait_enb = 1;
                        if (wait_done) next = INC_REG;
                        else next = BLANK;
                    end
                INC_REG:
                    begin
                        blank = 1;
                        abc_enb = 1;
                        next = WAIT;
                    end
                WAIT:
                    begin
                        blank = 1;
                        wait_enb = 1;
                        if (wait_done) next = LAT;
                        else next = WAIT;
                    end
                LAT:
                    begin
                        blank = 1;
                        lat = 1;
                        wait_enb = 1;
                        if (wait_done) next = LOAD;
                        else next = LAT;
                    end
            endcase
        end
                
    assign col_enb = sclk_done;
            
endmodule
