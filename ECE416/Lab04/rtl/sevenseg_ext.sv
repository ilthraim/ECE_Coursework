//////////////////////////////////////////////////////////////////////////////////
// Company: Lafayette College
// Engineer: Ethan Miller, John Burk
// 
// Create Date: 02/11/2021 01:22:12 PM
// Design Name: 
// Module Name: sevenseg_ext
// Project Name: Lab 01
// Target Devices: Nexys A7 
// Tool Versions: 
// Description: Seven segment decoder that's capable of taking inputs from switches or other data inputs
// to display on the FPGA
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module sevenseg_ext(
    input logic [6:0] d,
    output logic [6:0] segs_n,
    output logic dp_n
);

    logic [6:0] segs;

    assign dp_n = 1'b1;
    
    always_comb begin
        case (d[3:0])
            4'd0: segs = 7'b1111110;
            4'd1: segs = 7'b0110000;
            4'd2: segs = 7'b1101101;
            4'd3: segs = 7'b1111001;
            4'd4: segs = 7'b0110011;
            4'd5: segs = 7'b1011011;
            4'd6: segs = 7'b1011111;
            4'd7: segs = 7'b1110000;
            4'd8: segs = 7'b1111111;
            4'd9: segs = 7'b1110011;
            4'd10: segs = 7'b1110111;
            4'd11: segs = 7'b0011111;
            4'd12: segs = 7'b0001101;
            4'd13: segs = 7'b0111101;
            4'd14: segs = 7'b1001111;
            4'd15: segs = 7'b1000111;
            default: segs = 7'b0000000;
        endcase
        
        segs_n = ~segs;
    end
        
endmodule
