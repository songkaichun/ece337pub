// $Id: $
// File name:   full_adder.sv
// Created:     11/2/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Full Adder.

module full_adder
(
	input wire a,
	input wire b,
	input wire cin,
	output wire sum,
	output wire cout
);
	assign cout = (a & b) | ((a ^ b) & cin);
	assign sum = cin ^ (a ^ b);
endmodule;