module shreg (
    input logic clk, rst, sh_idle, sh_ld, sh_en,
    input logic [7:0] data,
    output logic txd);

    logic [9:0] q;

    assign txd = q[0];

  always_ff @(posedge clk)
    if (rst) q <= '0;
    else if (sh_idle) q <= 'b1;
    else if (sh_ld) q <= {1'b1, data, 1'b0};

    else if (sh_en) begin
        q <= {1'b1, q[9:1]};
    end

endmodule: shreg