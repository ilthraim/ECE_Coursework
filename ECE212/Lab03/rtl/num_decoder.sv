`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2019 08:06:49 AM
// Design Name: 
// Module Name: num_decoder
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


module num_decoder(input logic clk, rst, nextpb, [2:0] nextcolor,
                   output logic [3:0] WE, [9:0] WRADDR, [31:0] DI);
                   
    logic [3:0] count;
    logic [2:0] w_count;
    logic [3:0] coloro;

    assign WE = 4'b1111;
    assign coloro = {1'b0, nextcolor};
    
    always_comb
        begin
            DI = 0;
            
            case (count)
                4'd0 :
                    case (w_count)
                        3'd0 : DI = {4'b0, {6{coloro}}, 4'b0};
                        3'd1 : DI = {coloro, 24'b0, coloro};
                        3'd2 : DI = {coloro, 24'b0, coloro};
                        3'd3 : DI = {coloro, 24'b0, coloro};
                        3'd4 : DI = {4'b0, {6{coloro}}, 4'b0};
                    endcase
                4'd1 : 
                    case (w_count)
                        3'd0 : DI = 32'b0;
                        3'd1 : DI = {coloro, 20'b0, coloro, 4'b0};
                        3'd2 : DI = {8{coloro}};
                        3'd3 : DI = {coloro, 28'b0};
                        3'd4 : DI = 32'b0;
                    endcase
                4'd2 : 
                    case (w_count)
                        3'd0 : DI = {{2{coloro}}, 16'b0, coloro, 4'b0};
                        3'd1 : DI = {coloro, 4'b0, coloro, 16'b0, coloro};
                        3'd2 : DI = {coloro, 8'b0, coloro, 12'b0, coloro};
                        3'd3 : DI = {coloro, 12'b0, coloro, 8'b0, coloro};
                        3'd4 : DI = {coloro, 16'b0, {2{coloro}}, 4'b0};
                    endcase
                4'd3 : 
                    case (w_count)
                        3'd0 : DI = {4'b0, coloro, 16'b0, coloro, 4'b0};
                        3'd1 : DI = {coloro, 24'b0, coloro};
                        3'd2 : DI = {coloro, 12'b0, coloro, 8'b0, coloro};
                        3'd3 : DI = {coloro, 12'b0, coloro, 8'b0, coloro};
                        3'd4 : DI = {4'b0, {3{coloro}}, 4'b0, {2{coloro}}, 4'b0};
                    endcase
                4'd4 : 
                    case (w_count)
                        3'd0 : DI = {16'b0, {4{coloro}}};
                        3'd1 : DI = {16'b0, coloro, 12'b0};
                        3'd2 : DI = {16'b0, coloro, 12'b0};
                        3'd3 : DI = {16'b0, coloro, 12'b0};
                        3'd4 : DI = {8{coloro}};
                    endcase
                4'd5 : 
                    case (w_count)
                        3'd0 : DI = {4'b0, coloro, 8'b0, {4{coloro}}};
                        3'd1 : DI = {coloro, 12'b0, coloro, 8'b0, coloro};
                        3'd2 : DI = {coloro, 12'b0, coloro, 8'b0, coloro};
                        3'd3 : DI = {coloro, 12'b0, coloro, 8'b0, coloro};
                        3'd4 : DI = {4'b0, {3{coloro}}, 12'b0, coloro};
                    endcase
                4'd6 : 
                    case (w_count)
                        3'd0 : DI = {4'b0, {4{coloro}}, 12'b0};
                        3'd1 : DI = {coloro, 12'b0, {2{coloro}}, 8'b0};
                        3'd2 : DI = {coloro, 12'b0, coloro, 4'b0, coloro, 4'b0};
                        3'd3 : DI = {coloro, 12'b0, coloro, 8'b0, coloro};
                        3'd4 : DI = {4'b0, {3{coloro}}, 16'b0};
                    endcase
                4'd7 : 
                    case (w_count)
                        3'd0 : DI = {28'b0, coloro};
                        3'd1 : DI = {{2{coloro}}, 20'b0, coloro};
                        3'd2 : DI = {8'b0, {2{coloro}}, 12'b0, coloro};
                        3'd3 : DI = {16'b0, {2{coloro}}, 4'b0, coloro};
                        3'd4 : DI = {24'b0, {2{coloro}}};
                    endcase
                4'd8 : 
                    case (w_count)
                        3'd0 : DI = {4'b0, {2{coloro}}, 4'b0, {3{coloro}}, 4'b0};
                        3'd1 : DI = {coloro, 8'b0, coloro, 12'b0, coloro};
                        3'd2 : DI = {coloro, 8'b0, coloro, 12'b0, coloro};
                        3'd3 : DI = {coloro, 8'b0, coloro, 12'b0, coloro};
                        3'd4 : DI = {4'b0, {2{coloro}}, 4'b0, {3{coloro}}, 4'b0};
                    endcase
                4'd9 : 
                    case (w_count)
                        3'd0 : DI = {20'b0, {2{coloro}}, 4'b0};
                        3'd1 : DI = {16'b0, coloro, 8'b0, coloro};
                        3'd2 : DI = {16'b0, coloro, 8'b0, coloro};
                        3'd3 : DI = {16'b0, coloro, 8'b0, coloro};
                        3'd4 : DI = {{7{coloro}}, 4'b0};
                    endcase
            endcase
        end
        

    always_ff @(posedge clk)
        begin
            if (rst)
                begin
                    count <= 0;
                    w_count <= 0;
                    WRADDR <= 10'd94;
                end
            else
                begin
                
                    if (w_count == 3'd5)
                        begin
                            w_count <= 0;
                            WRADDR <= 10'd94;
                        end
                    else
                        begin
                            w_count <= w_count + 1;
                            WRADDR <= WRADDR + 1;
                        end
                
                    if (nextpb)
                        if (count == 4'd9)
                            count <= 0;
                        else
                            count <= count + 1;
                            
                end
        end
        
    
                   
endmodule
