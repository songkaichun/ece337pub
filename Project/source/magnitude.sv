// $Id: $
// File name:   magnitude.sv
// Created:     12/2/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Determiens the magnitude of X and Y convolution blocks.

module magnitude
(
	input wire clk,
	input wire n_rst,
	input wire [9:0] gx,
	input wire [9:0] gy,
	input wire calc_done,
	output reg [3:0] pixel,
	output reg output_enable
);

	reg [9:0] gx_unsigned_ext;
	reg [9:0] gy_unsigned_ext;
	reg [4:0] gx_unsigned;
	reg [4:0] gy_unsigned;
	reg [9:0] gx_squared;
	reg [9:0] nxt_gx_squared;
	reg [9:0] nxt_gy_squared;
	reg [9:0] gy_squared;
	reg [10:0] sum;
	reg [10:0] nxt_sum;
	reg oe1;

	always_comb
	begin
		if(gx[9] == 1'b1)
		begin
			gx_unsigned_ext = ~gx + 1'b1;
			gx_unsigned = gx_unsigned_ext[8:4];
		end
		else
		begin
			gx_unsigned_ext = 'b0;
			gx_unsigned = gx[8:4];
		end
		
		if(gy[9] == 1'b1)
		begin
			gy_unsigned_ext = ~gy + 1'b1;
			gy_unsigned = gy_unsigned_ext[8:4]; 
		end
		else
		begin
			gy_unsigned_ext = 'b0;
			gy_unsigned = gy[8:4];
		end
	end

	always_comb
	begin
		nxt_gx_squared = gx_unsigned * gx_unsigned;
		nxt_gy_squared = gy_unsigned * gy_unsigned;
	end

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
		begin
			gx_squared <= 10'd0;
			gy_squared <= 10'd0;
		end
		else
		begin
			gx_squared <= nxt_gx_squared;
			gy_squared <= nxt_gy_squared;
		end
	end

	always_ff @(posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
		begin
			oe1 <= 1'b0;
			output_enable <= 1'b0;
		end
		else
		begin
			oe1 <= calc_done;
			output_enable <= oe1;
		end
	end

	always_comb
	begin
		nxt_sum = gx_squared + gy_squared;
	end

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
		begin
			sum <= 11'd0;
		end
		else
		begin
			sum <= nxt_sum;
		end
	end

	always_comb
	begin
		if(sum >= 11'd0 && sum < 11'd3)
		begin
			pixel = 4'b0000;
		end
		else if(sum >= 11'd3 && sum < 11'd6)
		begin
			pixel = 4'b0001;
		end
		else if(sum >= 11'd6 && sum < 11'd9)
		begin
			pixel = 4'b0010;
		end
		else if(sum >= 11'd9 && sum < 11'd12)
		begin
			pixel = 4'b0011;
		end
		else if(sum >= 11'd12 && sum < 11'd15)
		begin
			pixel = 4'b0100;
		end
		else if(sum >= 11'd15 && sum < 11'd18)
		begin
			pixel = 4'b0101;
		end
		else if(sum >= 11'd18 && sum < 11'd21)
		begin
			pixel = 4'b0110;
		end
		else if(sum >= 11'd21 && sum < 11'd24)
		begin
			pixel = 4'b0111;
		end
		else if(sum >= 11'd24 && sum < 11'd27)
		begin
			pixel = 4'b1000;
		end
		else if(sum >= 11'd27 && sum < 11'd30)
		begin
			pixel = 4'b1001;
		end
		else if(sum >= 11'd30 && sum < 11'd33)
		begin
			pixel = 4'b1010;
		end
		else if(sum >= 11'd33 && sum < 11'd36)
		begin
			pixel = 4'b1011;
		end
		else if(sum >= 11'd36 && sum < 11'd39)
		begin
			pixel = 4'b1100;
		end
		else if(sum >= 11'd39 && sum < 11'd42)
		begin
			pixel = 4'b1101;
		end
		else if(sum >= 11'd42 && sum < 11'd45)
		begin
			pixel = 4'b1110;
		end
		else
		begin
			pixel = 4'b1111;
		end
	end
endmodule;

			


	
	 