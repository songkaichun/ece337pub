// $Id: $
// File name:   image_buffer.sv
// Created:     11/30/2017
// Author:      Reshav
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: AHBSobelEdgeTopSlave

module ahbMaster
(
input wire clk,
input wire HCLK,
input wire HRESETn,
input wire n_rst,
//address match decoder
input wire [31:0]  HADDR,
//data
input reg [15:0][8:0]  HWDATA, //this value gets manipulated by shifting data for writing on bus
//output pixel write to file
output reg EdgeDetectedPixel,
);
//read image if starting image assert and then deassert image_start flag to start reading image data into buffer

//start convolution process as soon as image data is available in line of buffer
//reg   [ 2:0]  HBURST;
//reg   [ 3:0]  HPROT;
//reg   [ 2:0]  HSIZE;
//reg   [ 1:0]  HTRANS;
//reg           HWRITE;
//reg   [31:0]  HRDATA; //data to be read to bus
//reg           HREADY;
//reg   [ 1:0]  HRESP;
reg HSEL_1;
reg HSEL_2;

//decoder
ahbSlaveDecoder decoder(
.HCLK(HCLK),.HRESETn(HRESETn),.HADDR(HADDR),.HSEL_1(HSEL_1),.HSEL_2(HSEL_2),.convolveStart(),.shiftData()
);
//MCU slave
//imgBufferSlave
//if the buffer is full do a convolution
endmodule
