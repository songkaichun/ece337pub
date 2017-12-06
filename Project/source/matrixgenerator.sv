// $Id: $
// File name:   matrixgenerator.sv
// Created:     12/4/2017
// Author:      Kaichun Song
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: generate matrix
module matrixgenerator
(
	input wire [3:0] bscalar,
	output wire [2:0][2:0][4:0] outx,
	output wire [2:0][2:0][4:0] outy
);
		
	assign outx[0][0] = 5'b00001;
	assign outx[0][1] = 5'b00000;
	assign outx[0][2] = 5'b11111;
	assign outx[1][0] = {1'b0, bscalar};
	assign outx[1][1] = 5'b00000;
	assign outx[1][2] = (~{1'b0, bscalar}) + 1'b1;
	assign outx[2][0] = 5'b00001;
	assign outx[2][1] = 5'b00000;
	assign outx[2][2] = 5'b11111;

	assign outy[0][0] = 5'b00001;
	assign outy[0][1] = {1'b0, bscalar};
	assign outy[0][2] = 5'b00001;
	assign outy[1][0] = 5'b00000;
	assign outy[1][1] = 5'b00000;
	assign outy[1][2] = 5'b00000;
	assign outy[2][0] = 5'b11111;
	assign outy[2][1] = (~{1'b0, bscalar}) + 1'b1;
	assign outy[2][2] = 5'b11111;
		
endmodule
