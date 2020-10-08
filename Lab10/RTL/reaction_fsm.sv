`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2018 08:02:27 AM
// Design Name: 
// Module Name: reaction_fsm
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


module reaction_fsm(
    input logic clk, rst, start, enter, rwait_done, wait5_done, time_late,
    output logic start_rwait, start_wait5, time_clr, time_en, rs_en,
    [2:0] color_r, color_g, color_b);
    
    typedef enum logic [2:0] {
        IDLE = 3'b000, RWAIT = 3'b001, ERR = 3'b010,
        RWAIT_DONE = 3'b011, ERR_LATE = 3'b100, ENTER = 3'b101
    } state_t;
    
    state_t state, next;
    
    always_ff @(posedge clk)
        if (rst)
            state <= IDLE;
        else
            state <= next;
        
    always_comb
        begin
            color_r = 0;
            color_g = 0;
            color_b = 0;
            start_rwait = 0;
            start_wait5 = 0;
            time_en = 0;
            time_clr = 0;
            rs_en = 0;
            next = IDLE;
            
            case (state)
                IDLE:
                    begin
                        if (start)
                            begin
                                start_rwait = 1;
                                next = RWAIT;
                            end
                        else
                            next = IDLE;
                    end
                RWAIT:
                    begin
                        time_clr = 1;
                        if (enter & ~rwait_done)
                            begin
                                next = ERR;
                                start_wait5 = 1;
                            end
                        else if (rwait_done)
                            next = RWAIT_DONE;
                        else
                            next = RWAIT;
                    end
                ERR:
                    begin
                        color_r = 3'd6;
                        if (wait5_done)
                            next = IDLE;
                        else
                            next = ERR;
                    end
                RWAIT_DONE:
                    begin
                        time_en = 1;
                        color_g = 3'd2;
                        color_r = 3'd2;
                        color_b = 3'd2;
                        if (time_late)
                            begin
                                start_wait5 = 1;
                                next = ERR_LATE;
                            end
                        else if (enter)
                            next = ENTER;
                        else
                            next = RWAIT_DONE;
                    end
                ERR_LATE:
                    begin
                        color_g = 3'd3;
                        color_r = 3'd3;
                        if (wait5_done)
                            next = IDLE;
                        else
                            next = ERR_LATE;
                    end
                ENTER:
                    begin
                        rs_en = 1;
                        if (start)
                            next = RWAIT;
                        else
                            next = ENTER;
                    end
            endcase
        end
    
    
endmodule
