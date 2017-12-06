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
	input wire [1:0] select,
	input reg [3:0] [3:0] [3:0] buffer_pixels,
	output reg [2:0] [2:0] [3:0] conv_pixels 
);

reg [3:0][3:0][3:0] buffer_px; 

genvar i;
genvar j;
genvar k;
generate
	for(i = 0; i < 4; i = i + 1)
	begin
		for(j = 0; j < 4; j = j + 1)
		begin
			for(k = 0; k < 4; k = k + 1)
			begin
				always_ff @ (posedge clk, negedge n_rst)
				begin
					if(n_rst == 1'b0)
					begin
						buffer_px[i][j][k] <= 1'b0;
					end
					if(load_enable)
					begin
						buffer_px[i][j][k] = buffer_pixels[i][j][k];
					end
				end
			end
		end
	end
endgenerate
		
always_comb
begin
	if(select == 2'b00)
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
	else if(select == 2'b01)
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
	else if(select == 2'b10)
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
	else
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
end 

endmodule;