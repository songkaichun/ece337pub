// $Id: $
// File name:   x_conv.sv
// Created:     12/2/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: X convolution Block

module x_conv 
(
	input wire clk,
	input wire n_rst,
	input wire calc_enable,
	input wire [2:0][2:0][3:0] pixels,
	input wire [2:0][2:0][4:0] filter,
	output wire calc_done,
	output reg [9:0] conv
);

	reg [4:0] a;
	reg [4:0] b;
	reg [9:0] prod;
	reg [9:0] nxt_conv;

	x_bit_select    BITS (.clk(clk), .n_rst(n_rst), .calc_enable(calc_enable), .pixels(pixels), .filter(filter), .a(a), .b(b), .calc_done(calc_done));
	n_bitmultiplier #(5) PROD (.a(a), .b(b), .product(prod));

	always_ff @ (negedge n_rst, posedge clk)
	begin
		if(n_rst == 1'b0)
		begin
			conv <= 10'b0000000000;
		end
		else
		begin
			conv <= nxt_conv;
		end
	end
	
	always_comb
	begin
		if(calc_done == 1'b1)
			nxt_conv = 10'd0;
		else
			nxt_conv = prod + conv;
	end
endmodule;