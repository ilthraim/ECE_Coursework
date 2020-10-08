`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2018 08:01:56 AM
// Design Name: 
// Module Name: turnsignal
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


module turnsignal(input logic left, right, haz, rst, clk,
				  output logic l1, r1);
					
	typedef enum logic [1:0] {
		IDLE = 2'b00, R = 2'b01, L = 2'b10, LR = 2'b11
	} states_t;
	
	states_t state, next;
	
	always_ff @(posedge clk)
		if (rst) state <= IDLE;
		else	 state <= next;
		
	always_comb
		begin
			next = IDLE;
			case (state)
				IDLE:
					if ((haz == 1'b1) || ((left == 1'b1) && (right == 1'b1)))
						next = LR;
					else if (left == 1'b1)
						next = L;
					else if (right == 1'b1)
						next = R;
				L:
					next = IDLE;
				R:
					next = IDLE;
				LR:
					next = IDLE;
			endcase
		end
		
	always_comb
		begin
			l1 = 1'b0;
			r1 = 1'b0;
			case (state)
				IDLE: begin
					   l1 = 1'b0;
					   r1 = 1'b0;
					end
				L: begin
					   l1 = 1'b1;
					   r1 = 1'b0;
					end
				R: begin
					   l1 = 1'b0;
					   r1 = 1'b1;
                   end
				LR: begin
					   l1 = 1'b1;
					   r1 = 1'b1;
					end
			endcase
		end
endmodule
