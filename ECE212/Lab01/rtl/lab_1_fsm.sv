`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2019 08:30:20 AM
// Design Name: 
// Module Name: lab_1_fsm
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


module lab_1_fsm(input logic clk, rst, enb, in,
                 output logic [15:0] leds);
    
    typedef enum logic [3:0] {INIT, RL, LR, ALT_LR, ALT_RL} state_t;
    
    state_t state, next;
                 
    always_ff @(posedge clk)
        begin
            if (rst)
                begin
                    state <= INIT;
                    leds = 16'b0;
                end
            else state <= next;
            
            if (enb)
                begin
                    case (state)
                        INIT:
                            if (!(leds == 16'b0) && !(leds == 16'hFFFF))
                                leds <= 16'b0;
                            else
                                leds <= ~leds;
                        RL:
                            if ((leds == 16'b0) || (leds == 16'hFFFF))
                                leds <= 16'b0000000000000001;
                            else if (leds == 16'b1000000000000000)
                                leds <= 16'b0000000000000001;
                            else
                                leds <= leds << 1;
                        LR:
                            if (leds == 16'b0000000000000001)
                                leds <= 16'b1000000000000000;
                            else
                                leds <= leds >> 1;
                        ALT_RL:
                            leds = leds << 1;
                        ALT_LR:
                            leds = leds >> 1;
                    endcase
                end
        end
        
    always_comb
        begin
            next = INIT;
            case (state)
                INIT:
                    if (in) next = RL;
                    else next = INIT;
                RL:
                    if (in) next = LR;
                    else next = RL;
                LR:
                    if (in) next = ALT_RL;
                    else next = LR;
                ALT_RL:
                    if (in) next = INIT;
                    else if (leds == 16'b1000000000000000)
                        next = ALT_LR;
                    else next = ALT_RL;
                ALT_LR:
                    if (in) next = INIT;
                    else if (leds == 16'b0000000000000001)
                        next = ALT_RL;
                    else next = ALT_LR;
            endcase
        end
                 
endmodule
