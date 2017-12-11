// $Id: $
// File name:   tb_ahbMaster.sv
// Created:     11/30/2017
// Author:      Reshav
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: TBMASTER

module tb_ahbMaster;
localparam CLOCK_PERIOD = 10;
localparam CHECK_DELAY = 2;

// AHB signals.
reg tb_HCLK=0;
reg tb_HRESETn;
reg [31:0]tb_HADDR = 32'd32;
//reg   [ 3:0]  tb_HPROT;
reg [ 2:0]tb_HSIZE;
//reg   [ 1:0]  HTRANS;
reg [15:0][8:0]tb_HWDATA;


reg tb_HWRITE;
//reg   [31:0]  HRDATA;
reg tb_HREADY;
//reg   [ 1:0]  HRESP;
//reg           HBUSREQ;
//reg           HGRANT;

// Slave response signals
reg tb_HSEL_1;
reg tb_HSEL_2;

// Instantiate a master module.
//generate tb_clk and HCLK
reg tb_clk=0;
reg tb_nrst=0;
always
begin: CLK_GEN
	#(CLOCK_PERIOD/2.0);
	tb_clk = 1;
	#(CLOCK_PERIOD/2.0);
	tb_HCLK = 1;
	tb_clk = 0;

	#(CLOCK_PERIOD/2.0);
	tb_clk = 1;
	#(CLOCK_PERIOD/2.0);
	tb_clk = 0;
	tb_HCLK = 0;
end
//read file
//enter enough data to fill the image buffer
//convolution done, remove data off of bus and then fill bus
ahbMaster master(.clk(tb_clk),.HCLK(tb_HCLK),.HRESETn(tb_HRESETn),.n_rst(tb_nrst),.HADDR(tb_HADDR),.HWDATA(tb_HWDATA),
.EdgeDetectedPixel(tb_EdgeDetectedPixel),.HSEL_1(tb_HSEL_1),.HSEL_2(tb_HSEL_2));
//write combinational block to iterate through buffer
//ShiftData
reg convolveDone = 0;
reg shiftData = 0;
integer d = 0;
integer counter = 0;
//fill data into buffer until no more data can be written to bus
integer file  = $fopen("data.txt","r");
integer statusI;
integer tb_busIndex = 0; 
integer pix = 0;
reg tb_buffFull = 1;
//simple block for if buffFull 0 then reset cnt to 0
//write block to check status of buffer
generate
	always @(posedge tb_clk) begin
		if(tb_buffFull == 0) begin
			if(tb_busIndex == 16) begin
				tb_buffFull = 1;
			end else begin
				statusI = $fscanf(file,"%d",pix);
				pix = pix/16;
				tb_HWDATA[tb_busIndex] = pix;	
				tb_busIndex++;
			end
		end
	end
endgenerate


 //System reset.
initial begin
         tb_HRESETn = 1'b0;
	 tb_nrst = 1'b0;
    	#4ns tb_HRESETn = 1'b1; tb_nrst = 1'b0;
	#4ps tb_buffFull = 1;
	#8ps tb_buffFull = 0;
	#80ps tb_buffFull = 1;

end
endmodule
