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

	input wire HSEL,
	input wire HREADY,
	input wire [31:0] HADDR,
	input wire [1:0] HTRANS,
	input wire HWRITE,
	input wire [2:0] HSIZE,
	input wire [67:0] HWDATA,
	
	output reg HREADYOUT,
	output reg [67:0] HRDATA

);
	reg [3:0][3:0][3:0] input_pixels;
	reg [3:0] brightness_value;
	reg [2:0][2:0][3:0] out_px;
	reg [2:0][2:0][4:0] outx;
	reg [2:0][2:0][4:0] outy;
	reg [9:0] convx;
	reg [9:0] convy;
	reg x_calc_done;
	reg y_calc_done;
	reg calc_enable;
	reg load_enable;
	reg output_enable;
	reg [3:0] output_pixel;

	ahb_interface   INT    (.HCLK(clk), .HRESETn(n_rst), .HREADY(HREADY), .HADDR(HADDR), .HSEL(HSEL), .HTRANS(HTRANS), .HWRITE(HWRITE), .HSIZE(HSIZE), .HWDATA(HWDATA), .HREADYOUT(HREADYOUT), .HRDATA(HRDATA), .output_enable(output_enable), .pixel(output_pixel), .pixels(input_pixels), .load_enable(load_enable), .brightness_value(brightness_value));
	image_buffer    BUFF   (.clk(clk), .n_rst(n_rst), .calc_done(x_calc_done & y_calc_done), .load_enable(load_enable), .input_pixels(input_pixels), .output_pixels(out_px), .calc_enable(calc_enable));
	matrixgenerator MATRIX (.bscalar(brightness_value), .outx(outx), .outy(outy));
	x_conv          XCONV  (.clk(clk), .n_rst(n_rst), .calc_enable(calc_enable), .pixels(out_px), .filter(outx), .calc_done(x_calc_done), .conv(convx));
        y_conv          YCONV  (.clk(clk), .n_rst(n_rst), .calc_enable(calc_enable), .pixels(out_px), .filter(outy), .calc_done(y_calc_done), .conv(convy));
	magnitude       MAG    (.clk(clk), .n_rst(n_rst), .gx(convx), .gy(convy), .calc_done(x_calc_done & y_calc_done), .pixel(output_pixel), .output_enable(output_enable));
	
endmodule;