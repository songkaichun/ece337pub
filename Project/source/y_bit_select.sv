// $Id: $
// File name:   y_bit_select.sv
// Created:     12/2/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Bit select fort he y direction for X and Y convolution blocks

module y_bit_select
(
	input wire clk,
	input wire n_rst,
	input wire calc_enable,
	input wire [2:0][2:0][3:0] pixels,
	input wire [2:0][2:0][4:0] filter,
	output reg [4:0] a,
	output reg [4:0] b,
	output reg calc_done
);
	typedef enum bit [3:0] {IDLE, Gy1, Gy2, Gy3, Gy4, Gy5, Gy6, DONE} stateType;
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
			if(calc_enable == 1'b1)
			begin
				nxt_state = Gy1;
			end
		end
		else if (state == Gy1)
		begin
			nxt_state = Gy2;
		end
		else if (state == Gy2)
		begin
			nxt_state = Gy3;
		end
		else if (state == Gy3)
		begin
			nxt_state = Gy4;
		end
		else if (state == Gy4)
		begin
			nxt_state = Gy5;
		end
		else if (state == Gy5)
		begin
			nxt_state = Gy6;
		end
		else if (state == Gy6)
		begin
			nxt_state = DONE;
		end
		else if (state == DONE)
		begin
			nxt_state = IDLE;
		end
	end

	always_comb
	begin
		a = 4'b000;
		b = 4'b000;
		calc_done = 1'b0;

		if(state == Gy1)
		begin
			a = filter[0][0];
			b = {1'b0, pixels[0][0]};
		end
		else if(state == Gy2)
		begin
			a = filter[2][0];
			b = {1'b0, pixels[0][2]};
		end
		else if(state == Gy3)
		begin
			a = filter[0][1];
			b = {1'b0, pixels[1][0]};
		end
		else if(state == Gy4)
		begin
			a = filter[2][1];
			b = {1'b0, pixels[1][2]};
		end
		else if(state == Gy5)
		begin
			a = filter[0][2];
			b = {1'b0, pixels[2][0]};
		end
		else if(state == Gy6)
		begin
			a = filter[2][2];
			b = {1'b0, pixels[2][2]};
		end
		else if(state == DONE)
		begin
			calc_done = 1'b1;
		end
	end

endmodule;