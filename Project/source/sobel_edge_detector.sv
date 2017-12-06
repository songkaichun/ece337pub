// $Id: $
// File name:   sobel_edge_detector.sv
// Created:     12/6/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Top Level source file for sobel edge detection system.

module sobel_edge_detector
(
	input wire clk,
	input wire n_rst,
	input wire bus_data_ready,
	input reg [3:0] brightness_value,
	input reg [3:0] [3:0] [3:0]input_pixels,
	output reg [3:0] output_pixel, 
	output reg output_enable,
	output reg need_data
);
	reg [2:0][2:0][3:0] out_px;
	reg [2:0][2:0][4:0] outx;
	reg [2:0][2:0][4:0] outy;
	reg [9:0] convx;
	reg [9:0] convy;
	reg calc_done;
	reg calc_enable;
	reg load_enable;

	mcu             MCU    (.clk(clk), .n_rst(n_rst), .bus_data_ready(bus_data_ready), .calc_done(calc_done), .load_enable(load_enable), .output_enable(output_enable));
	image_buffer    BUFF   (.clk(clk), .n_rst(n_rst), .calc_done(calc_done), .load_enable(load_enable), .input_pixels(input_pixels), .output_pixels(out_px), .calc_enable(calc_enable), .need_data(need_data));
	matrixgenerator MATRIX (.bscalar(brightness_scalar), .outx(outx), .outy(outy));
	x_conv          XCONV  (.clk(clk), .n_rst(n_rst), .calc_enable(calc_enable), .pixels(out_px), .filter(outx), .calc_done(calc_done), .conv(convx));
        y_conv          YCONV  (.clk(clk), .n_rst(n_rst), .calc_enable(calc_enable), .pixels(out_px), .filter(outy), .calc_done(calc_done), .conv(convy));
	magnitude       MAG    (.clk(clk), .n_rst(n_rst), .gx(convx), .gy(convy), .pixel(output_pixel));
	
endmodule;