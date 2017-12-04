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
	input reg [3:0] [3:0] [3:0] buffer_pixels,
	output reg [2:0] [2:0] [3:0] conv_pixels 
);

	reg [1:0] select;

	pixels_select PIXELS (.clk(clk), .n_rst(n_rst), .calc_done(calc_done), .select(select));
	pixel_matrix  MATRIX (.clk(clk), .n_rst(n_rst), .load_enable(load_enable), .select(select), .buffer_pixels(buffer_pixels), .conv_pixels(conv_pixels));
endmodule;