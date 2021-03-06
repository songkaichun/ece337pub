// $Id: $
// File name:   n_bitmultiplier.sv
// Created:     11/1/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: n bit multiplier

module n_bitmultiplier
#(
	parameter BIT_WIDTH = 4
)
(
	input wire [(BIT_WIDTH-1):0] a,
	input wire [(BIT_WIDTH-1):0] b,
	output wire [((2*BIT_WIDTH)-1):0] product
);

	wire [((2*BIT_WIDTH)-1):0] padded_a;
	wire [((2*BIT_WIDTH)-1):0] padded_b;
	wire [((2*BIT_WIDTH)-1):0] [((2*BIT_WIDTH)-1):0]inputs;
	wire [((2*BIT_WIDTH)-1):0] [((2*BIT_WIDTH)-1):0] sums_in;
	wire [((2*BIT_WIDTH)-1):0] [((2*BIT_WIDTH)-1):0] sums_out;
	wire [((2*BIT_WIDTH)-1):0] [((2*BIT_WIDTH)-1):0] carrys_in;
	wire [((2*BIT_WIDTH)-1):0] [(2*BIT_WIDTH):0] carrys_out;

	assign padded_a = (a[BIT_WIDTH-1]) ? {{BIT_WIDTH{1'b1}}, a} : {{BIT_WIDTH{1'b0}}, a};
	assign padded_b = (b[BIT_WIDTH-1]) ? {{BIT_WIDTH{1'b1}}, b} : {{BIT_WIDTH{1'b0}}, b};
	assign carrys_in[0] = 'b0;
	assign sums_in[0] = 'b0;

	/**assign carrys_in[1] = carrys_out[0];
	assign carrys_in[2] = carrys_out[1];
	assign carrys_in[3] = carrys_out[2];

	assign sums_in[1] = sums_out[0];
	assign sums_in[2] = sums_out[1];
	assign sums_in[3] = sums_out[2];**/

	genvar i;
	genvar j;
	generate
		for(i = 0; i < 2*(BIT_WIDTH); i = i + 1)
		begin
			if(i != 0)
			begin
				assign carrys_in[i] = carrys_out[i-1];
				assign sums_in[i] = sums_out[i-1];
			end
			assign product[i] = sums_out[i][i];
			for(j = 0; j < 2*(BIT_WIDTH); j = j + 1)
			begin
				assign inputs[i][j] = padded_b[i] & padded_a[j];
			end
		end
	endgenerate

	generate
		for(i = 0; i < 2*(BIT_WIDTH); i = i + 1)
		begin
			for(j = i; j < 2*(BIT_WIDTH); j = j + 1)
			begin
				full_adder ADD (.a(sums_in[i][j]), .b(inputs[i][j-i]), .cin(carrys_in[i][j]), .sum(sums_out[i][j]), .cout(carrys_out[i][j+1]));
			end
		end
	endgenerate
	
	/**full_adder A0B0 (.a(sums_in[0][0]), .b(inputs[0][0]), .cin(carrys_in[0][0]), .sum(sums_out[0][0]), .cout(carrys_out[0][1]));
	full_adder A1B0 (.a(sums_in[0][1]), .b(inputs[0][1]), .cin(carrys_in[0][1]), .sum(sums_out[0][1]), .cout(carrys_out[0][2]));
	full_adder A2B0 (.a(sums_in[0][2]), .b(inputs[0][2]), .cin(carrys_in[0][2]), .sum(sums_out[0][2]), .cout(carrys_out[0][3]));
	full_adder A3B0 (.a(sums_in[0][3]), .b(inputs[0][3]), .cin(carrys_in[0][3]), .sum(sums_out[0][3]), .cout(carrys_out[0][0]));

	full_adder A0B1 (.a(sums_in[1][1]), .b(inputs[1][0]), .cin(carrys_in[1][1]), .sum(sums_out[1][1]), .cout(carrys_out[1][2]));
	full_adder A1B1 (.a(sums_in[1][2]), .b(inputs[1][1]), .cin(carrys_in[1][2]), .sum(sums_out[1][2]), .cout(carrys_out[1][3]));
	full_adder A2B1 (.a(sums_in[1][3]), .b(inputs[1][2]), .cin(carrys_in[1][3]), .sum(sums_out[1][3]), .cout(carrys_out[0][0]));

	full_adder A0B2 (.a(sums_in[2][2]), .b(inputs[2][0]), .cin(carrys_in[2][2]), .sum(sums_out[2][2]), .cout(carrys_out[2][3]));
	full_adder A2B2 (.a(sums_in[2][3]), .b(inputs[3][1]), .cin(carrys_in[2][3]), .sum(sums_out[2][3]), .cout(carrys_out[0][0]));

	full_adder A0B3 (.a(sums_in[3][3]), .b(inputs[3][0]), .cin(carrys_in[3][3]), .sum(sums_out[3][3]), .cout(carrys_out[0][0]));**/

endmodule;