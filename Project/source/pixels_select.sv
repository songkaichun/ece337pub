// $Id: $
// File name:   pixels_select.sv
// Created:     11/30/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Pixel Select Logic for the Image Input Buffer

module pixels_select
(
	input wire clk,
	input wire n_rst,
	input wire calc_done,
	input wire load_enable,
	output reg [2:0] select,
	output reg calc_enable
);
	typedef enum bit [2:0] {IDLE, S0, S1, S2, S3} stateType;
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
			if(load_enable == 1'b1)
			begin
				nxt_state = S0;
			end
		end
		else if(state == S0)
		begin
			if(calc_done == 1'b1)
			begin
				nxt_state = S1;
			end
			else if(load_enable == 1'b1)
			begin
				nxt_state = S0;
			end
		end
		else if (state == S1)
		begin
			if(calc_done == 1'b1)
			begin
				nxt_state = S2;
			end
			else if(load_enable == 1'b1)
			begin
				nxt_state = S0;
			end
		end
		else if (state == S2)
		begin
			if(calc_done == 1'b1)
			begin
				nxt_state = S3;
			end
			else if(load_enable == 1'b1)
			begin
				nxt_state = S0;
			end
		end
		else if (state == S3)
		begin
			if(calc_done == 1'b1)
			begin
				nxt_state = IDLE;
			end
			else if(load_enable == 1'b1)
			begin
				nxt_state = S0;
			end
		end
	end

	always_comb
	begin
		if(state == IDLE)
		begin
			select = 3'b000;
			calc_enable = 1'b0;
		end
		else if(state == S0)
		begin
			select = 3'b001;
			calc_enable = 1'b1;
		end
		else if(state == S1)
		begin
			select = 3'b010;
			calc_enable = 1'b1;
		end
		else if(state == S2)
		begin
			select = 3'b011;
			calc_enable = 1'b1;
		end
		else if(state == S3)
		begin
			select = 3'b100;
			calc_enable = 1'b1;
		end
	end

endmodule;