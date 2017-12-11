// $Id: $
// File name:   image_buffer.sv
// Created:     11/30/2017
// Author:      Reshav
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: AHBSobelEdgeTopSlave

module ahbSlaveDecoder
(
input wire HCLK,
input wire HRESETn,
//address match decoder
input wire [31:0]  HADDR,
input wire shiftData,
input wire convoleStart,
output wire HSEL_1,
output wire HSEL_2
);

reg address_match;
//signal for image buffer slave (slave response signal)
//signal for MCU to start a convolution (controlled if Image Buffer data is available)

always_ff @(negedge HRESETn,posedge HCLK)
begin
	if(HRESETn == 0) begin
		convolveStart <= 0;
		shiftData <= 0;
	end 
	
end

assign address_match = (HADDR[31:0] == 32'd32 && HRESETn == 1);
assign HSEL_1 = (address_match && convolveStart); //MCU slave
assign HSEL_2 = (address_match && shiftData); //IMGBUFFER slave
	
endmodule
