module count_2bit ( input logic clk, rst,
	       output logic [1:0] q );
   
   always_ff @(posedge clk)
     if (rst) q <= 2'd0;
     else q <= q + 2'd1;

endmodule // count