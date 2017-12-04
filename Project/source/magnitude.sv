// $Id: $
// File name:   magnitude.sv
// Created:     12/2/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Determiens the magnitude of X and Y convolution blocks.

module magnitude
(
	input wire [9:0] gx,
	input wire [9:0] gy,
	input wire calc_done
)

	reg [9:0] gx