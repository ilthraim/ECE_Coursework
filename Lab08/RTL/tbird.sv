`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2018 08:46:09 AM
// Design Name: 
// Module Name: tbird
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


module tbird(input logic clk, rst, left, right, haz,
             output logic lc, lb, la, ra, rb, rc);
     
     typedef enum logic [5:0] {
        IDLE = 6'b000000, 
        L1 = 6'b001000, L2 = 6'b011000, L3 = 6'b111000,
        R1 = 6'b000100, R2 = 6'b000110, R3 = 6'b000111,
        H1 = 6'b001100, H2 = 6'b011110, H3 = 6'b111111
    } states_t;
    
    states_t state, next;
    
    always_ff @(posedge clk)
        if (rst) state <= IDLE;
        else     state <= next;
        
    always_comb
        begin
            {lc, lb, la, ra, rb, rc} = state;
            next = IDLE;
            case (state)
                IDLE:
                    if ((haz == 1'b1) || ((left == 1'b1) && (right == 1'b1)))
                        next = H1;
                    else if (left == 1'b1)
                        next = L1;
                    else if (right == 1'b1)
                        next = R1;
                L1:
                    next = L2;
                L2:
                    next = L3;
                L3:
                    next = IDLE;
                R1:
                    next = R2;
                R2:
                    next = R3;
                R3:
                    next = IDLE;
                H1:
                    next = H2;
                H2:
                    next = H3;
                H3:
                    next = IDLE;
            endcase
        end
     
endmodule
