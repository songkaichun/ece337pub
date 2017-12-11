// $Id: $
// File name:   mcu.sv
// Created:     12/6/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Main Control Unit for Sobel Edge Detector.

module mcu
(
	input wire clk,
	input wire HSEL_1,
	input wire n_rst,
	input wire dataAvailable,
	input wire x_calc_done,
	input wire y_calc_done,
	output reg load_enable,
	output reg output_enable,
	output reg convolutionDone
);

typedef enum bit [2:0] {IDLE, ReadBuffer, SobelFilterGeneration, XGen, YGen, MagGen, OutputPixel, ImageDone} stateType;
	stateType state;
	stateType nxt_state;


	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
		begin
			state <= IDLE;
		end
		else
		begin
			state <= nxt_state;
		end
	end

	always_comb
	begin
		nxt_state = state;
		case(state)
		IDLE: begin
			if(HSEL_1) begin
				//MCU slave has not been activated
				next_state = IDLE;
			end else begin
				//start convolution
				next_state = ReadBuffer;
			end
		end
		ReadBuffer: begin
			//read image buffer (set flag)
			//filter generation flag
			//filter always there, unless new img config flag is asserted then make new filter
			
			if(dataAvailable) begin
				//transfer data assert y and x 
				next_state = 
			end
			else begin
				next_state = ReadBuffer;
			end
		end
		endcase
	end
endmodule;