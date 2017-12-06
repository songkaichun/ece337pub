// $Id: $
// File name:   image_buffer.sv
// Created:     11/30/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Image Buffer.

module image_buffer
(
	input wire clk,
	input wire n_rst,
	input wire calc_done,
	input wire load_enable,
	input reg [3:0] [3:0] [3:0]input_pixels,
	output reg [2:0] [2:0] [3:0] output_pixels,
	output wire calc_enable 
);

	reg [2:0] select;

	pixels_select PIXELS (.clk(clk), .n_rst(n_rst), .calc_done(calc_done), .load_enable(load_enable), .select(select), .calc_enable(calc_enable));
	pixel_matrix  MATRIX (.clk(clk), .n_rst(n_rst), .load_enable(load_enable), .select(select), .buffer_pixels(input_pixels), .conv_pixels(output_pixels));
endmodule;