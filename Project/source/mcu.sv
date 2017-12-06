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
	input wire n_rst,
	input wire bus_data_ready,
	input wire calc_done,
	output reg load_enable,
	output reg output_enable
);

typedef enum bit [2:0] {IDLE, WAIT1, LE, LEWAIT1, OE, LEOE} stateType;
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
		if(state == IDLE)
		begin
			if(bus_data_ready == 1'b1 && calc_done == 1'b1)
			begin
				nxt_state = LEWAIT1;
			end
			else if(bus_data_ready == 1'b1)
			begin
				nxt_state = LE;
			end
			else if(calc_done == 1'b1)
			begin
				nxt_state = WAIT1;
			end
			else
			begin
				nxt_state = IDLE;
			end
		end
		else if(state == WAIT1)
		begin
			if(bus_data_ready == 1'b1)
			begin
				nxt_state = LEOE;
			end
			else
			begin
				nxt_state = OE;
			end
		end
		else if (state == LE)
		begin
			if(calc_done == 1'b1)
			begin
				nxt_state = WAIT1;
			end
			else
			begin
				nxt_state = IDLE;
			end
		end
		else if (state == LEWAIT1)
		begin
			nxt_state = OE;
		end
		else if (state == OE)
		begin
			if(bus_data_ready == 1'b1)
			begin
				nxt_state = LE;
			end
			else
			begin
				nxt_state = IDLE;
			end
		end
		else if (state == LEOE)
		begin
			nxt_state = IDLE;
		end
	end

	always_comb
	begin
		if(state == IDLE)
		begin
			load_enable = 1'b0;
			output_enable = 1'b0;
		end
		else if(state == WAIT1)
		begin
			load_enable = 1'b0;
			output_enable = 1'b0;
		end
		else if(state == LE)
		begin
			load_enable = 1'b1;
			output_enable = 1'b0;
		end
		else if(state == OE)
		begin
			load_enable = 1'b0;
			output_enable = 1'b1;
		end
		else if(state == LEWAIT1)
		begin
			load_enable = 1'b1;
			output_enable = 1'b0;
		end
		else if(state == LEOE)
		begin
			load_enable = 1'b1;
			output_enable = 1'b1;
		end
	end
endmodule;