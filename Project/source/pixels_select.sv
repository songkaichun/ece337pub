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
	output reg [1:0] select
);
	typedef enum bit [1:0] {S0, S1, S2, S3} stateType;
	stateType state;
	stateType nxt_state;


	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
		begin
			state <= S0;
		end
		else
		begin
			state <= nxt_state;
		end
	end

	always_comb
	begin
		nxt_state = state;
		
		if(state == S0)
		begin
			if(calc_done == 1'b1)
			begin
				nxt_state = S1;
			end
		end
		else if (state == S1)
		begin
			if(calc_done == 1'b1)
			begin
				nxt_state = S2;
			end
		end
		else if (state == S2)
		begin
			if(calc_done == 1'b1)
			begin
				nxt_state = S3;
			end
		end
		else if (state == S3)
		begin
			if(calc_done == 1'b1)
			begin
				nxt_state = S0;
			end
		end
	end

	always_comb
	begin
		if(state == S0)
		begin
			select = 2'b00;
		end
		else if(state == S1)
		begin
			select = 2'b01;
		end
		else if(state == S2)
		begin
			select = 2'b10;
		end
		else if(state == S3)
		begin
			select = 2'b11;
		end
	end

endmodule;