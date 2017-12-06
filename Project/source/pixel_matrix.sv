// $Id: $
// File name:   pixel_matrix.sv
// Created:     11/30/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Pixel Matrix

module pixel_matrix
(
	input wire clk,
	input wire n_rst,
	input wire load_enable,
	input wire [2:0] select,
	input reg [3:0] [3:0] [3:0] buffer_pixels,
	output reg [2:0] [2:0] [3:0] conv_pixels 
);

reg [3:0][3:0][3:0] buffer_px; 

always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 1'b0)
	begin
		buffer_px[0][0] <= 4'b0;
		buffer_px[0][1] <= 4'b0;
		buffer_px[0][2] <= 4'b0;		
		buffer_px[0][3] <= 4'b0;
		buffer_px[1][0] <= 4'b0;
		buffer_px[1][1] <= 4'b0;
		buffer_px[1][2] <= 4'b0;		
		buffer_px[1][3] <= 4'b0;
		buffer_px[2][0] <= 4'b0;
		buffer_px[2][1] <= 4'b0;
		buffer_px[2][2] <= 4'b0;		
		buffer_px[2][3] <= 4'b0;
		buffer_px[3][0] <= 4'b0;
		buffer_px[3][1] <= 4'b0;
		buffer_px[3][2] <= 4'b0;		
		buffer_px[3][3] <= 4'b0;
	end
	else if(load_enable == 1'b1)
	begin
		buffer_px[0][0] <= buffer_pixels[0][0];
		buffer_px[0][1] <= buffer_pixels[0][1];
		buffer_px[0][2] <= buffer_pixels[0][2];
		buffer_px[0][3] <= buffer_pixels[0][3];
		buffer_px[1][0] <= buffer_pixels[1][0];
		buffer_px[1][1] <= buffer_pixels[1][1];
		buffer_px[1][2] <= buffer_pixels[1][2];
		buffer_px[1][3] <= buffer_pixels[1][3];
		buffer_px[2][0] <= buffer_pixels[2][0];
		buffer_px[2][1] <= buffer_pixels[2][1];
		buffer_px[2][2] <= buffer_pixels[2][2];
		buffer_px[2][3] <= buffer_pixels[2][3];
		buffer_px[3][0] <= buffer_pixels[3][0];
		buffer_px[3][1] <= buffer_pixels[3][1];
		buffer_px[3][2] <= buffer_pixels[3][2];
		buffer_px[3][3] <= buffer_pixels[3][3];
	end
end
		
always_comb
begin
	if(select == 3'b001)
	begin
		conv_pixels[0][0] = buffer_px[0][0];
		conv_pixels[0][1] = buffer_px[0][1];
		conv_pixels[0][2] = buffer_px[0][2];
		conv_pixels[1][0] = buffer_px[1][0];
		conv_pixels[1][1] = buffer_px[1][1];
		conv_pixels[1][2] = buffer_px[1][2];
		conv_pixels[2][0] = buffer_px[2][0];
		conv_pixels[2][1] = buffer_px[2][1];
		conv_pixels[2][2] = buffer_px[2][2];
	end
	else if(select == 3'b010)
	begin
		conv_pixels[0][0] = buffer_px[0][1];
		conv_pixels[0][1] = buffer_px[0][2];
		conv_pixels[0][2] = buffer_px[0][3];
		conv_pixels[1][0] = buffer_px[1][1];
		conv_pixels[1][1] = buffer_px[1][2];
		conv_pixels[1][2] = buffer_px[1][3];
		conv_pixels[2][0] = buffer_px[2][1];
		conv_pixels[2][1] = buffer_px[2][2];
		conv_pixels[2][2] = buffer_px[2][3];
	end
	else if(select == 3'b011)
	begin
		conv_pixels[0][0] = buffer_px[1][0];
		conv_pixels[0][1] = buffer_px[1][1];
		conv_pixels[0][2] = buffer_px[1][2];
		conv_pixels[1][0] = buffer_px[2][0];
		conv_pixels[1][1] = buffer_px[2][1];
		conv_pixels[1][2] = buffer_px[2][2];
		conv_pixels[2][0] = buffer_px[3][0];
		conv_pixels[2][1] = buffer_px[3][1];
		conv_pixels[2][2] = buffer_px[3][2];
	end
	else if(select == 3'b100)
	begin
		conv_pixels[0][0] = buffer_px[1][1];
		conv_pixels[0][1] = buffer_px[1][2];
		conv_pixels[0][2] = buffer_px[1][3];
		conv_pixels[1][0] = buffer_px[2][1];
		conv_pixels[1][1] = buffer_px[2][2];
		conv_pixels[1][2] = buffer_px[2][3];
		conv_pixels[2][0] = buffer_px[3][1];
		conv_pixels[2][1] = buffer_px[3][2];
		conv_pixels[2][2] = buffer_px[3][3];
	end
	else
	begin
		conv_pixels[0][0] = 4'b0000;
		conv_pixels[0][1] = 4'b0000;
		conv_pixels[0][2] = 4'b0000;
		conv_pixels[1][0] = 4'b0000;
		conv_pixels[1][1] = 4'b0000;
		conv_pixels[1][2] = 4'b0000;
		conv_pixels[2][0] = 4'b0000;
		conv_pixels[2][1] = 4'b0000;
		conv_pixels[2][2] = 4'b0000;
	end
end 

endmodule;