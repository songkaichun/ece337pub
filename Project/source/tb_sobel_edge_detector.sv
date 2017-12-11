// $Id: $
// File name:   tb_sobel_edge_detector.sv
// Created:     12/6/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Top Level Sobel Edge Detector.
module tb_sobel_edge_detector();
	parameter		INPUT_FILENAME		= "./docs/InputDataFile.txt";
	parameter		OUTPUT_FILENAME		= "./docs/ImageOutputFile.txt";
	
	// Txt file based parameters
	localparam IMG_HEIGHT			= 300;	
	localparam IMG_WIDTH			= 400;
	localparam BITS_PER_PIXEL		=4;

	// Define local constants
	localparam NUM_VAL_BITS	= 16;
	localparam MAX_VAL_BIT	= NUM_VAL_BITS - 1;
	localparam CHECK_DELAY	= 3ns;
	localparam CLK_PERIOD	= 10ns;
	
	
	// Test bench dut port signals
	reg tb_HCLK;
	reg tb_HRESETn;
	reg tb_HSEL;
	reg tb_HREADY;
	reg [31:0] tb_HADDR;
	reg [1:0] tb_HTRANS;
	reg tb_HWRITE;
	reg [2:0] tb_HSIZE;
	reg [67:0] tb_HWDATA;
	reg tb_HREADYOUT;
	reg [67:0] tb_HRDATA;
	
	// Declare Test Bench Variables					
	reg [IMG_HEIGHT:0][IMG_WIDTH:0][3:0] image;
	reg [IMG_HEIGHT:0][IMG_WIDTH:0][3:0] out_image;
	reg [67:0] expected_HRDATA;
	reg expected_HREADYOUT;
	reg [3:0] brightness_value;
	integer test_num = 0;
	integer error_count = 0;
	integer out_row = 1;
	integer out_col = 1;
	integer in_file;							// Input file handle
	integer out_file;							// Result file handle
	integer i;
	integer j;	
	integer k;							// Loop variable for misc. for loops
	integer m;
	integer n;
	integer q;
	integer r;
	
	task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronize with clock)
		tb_HRESETn = 1'b0;
		
		// Wait for a couple clock cycles
		@(posedge tb_HCLK);
		@(posedge tb_HCLK);
		
		// Release the reset
		@(negedge tb_HCLK);
		tb_HRESETn = 1;
		
		// Wait for a while before activating the design
		@(posedge tb_HCLK);
	end
	endtask
	
	// Clock gen block
	always
	begin : CLK_GEN
		tb_HCLK = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_HCLK = 1'b1;
		#(CLK_PERIOD / 2.0);
	end
	
	// DUT portmap
	sobel_edge_detector EDGE(
									.clk(tb_HCLK),
									.n_rst(tb_HRESETn),
									.HSEL(tb_HSEL),
									.HADDR(tb_HADDR),
									.HTRANS(tb_HTRANS),
									.HWRITE(tb_HWRITE),
									.HSIZE(tb_HSIZE),
									.HWDATA(tb_HWDATA),
									.HREADY(tb_HREADY),
									.HREADYOUT(tb_HREADYOUT),
									.HRDATA(tb_HRDATA)
								);
		
	task set_out_image_borders;
	begin
		for(i = 0; i < IMG_HEIGHT; i++)
		begin
			for(j = 0; j < IMG_WIDTH; j++)
			begin
				if(i == 0 || j == 0)
					out_image[i][j] = 4'b0000;
			end
		end
	end
	endtask 

	task load_image;
	begin
		in_file = $fopen(INPUT_FILENAME, "r");
		for(i = 0; i < IMG_HEIGHT; i++)
		begin
			for(j = 0; j < IMG_WIDTH; j++)
			begin
				$fscanf(in_file, "%h ", image[i][j]);
			end
		end
		$fclose(in_file);
	end
	endtask	

	task set_HWDATA;
		input integer r;
		input integer c;
	begin
		q = 67;
		for(i = r; i < r+4; i++)
		begin
			for(j = c; j < c+4; j++)
			begin
				for(k = 3; k >= 0; k--)
				begin
					tb_HWDATA[q] = image[i][j][k];
					q = q - 1;
				end
			end
		end
		tb_HWDATA[3:0] = brightness_value;
	end
	endtask

	task store_pixel;
		input integer pix;
	begin
		out_image[out_row][out_col] = pix;
		out_col = out_col + 1;
		if(out_col == 399)
		begin
			out_col = 1;
			out_row = out_row+1;
		end 
	end
	endtask
		

	task check_outputs;
	begin
		#CHECK_DELAY
		if(expected_HRDATA == tb_HRDATA)
		begin
			$display("Correct value of HRDATA");
		end
		else
		begin
			$error("Incorrect value of HRDATA");
			error_count = error_count + 1;
		end
		if(expected_HREADYOUT == tb_HREADYOUT)
		begin
			$display("Correct value of %d for HREADYOUT", tb_HREADYOUT);
		end
		else
		begin
			$error("Incorrect value of %d for HREADYOUT", tb_HREADYOUT);
			error_count = error_count + 1;
		end
	end
	endtask	
	// Test bench process
	initial
	begin
		// Initial values
		tb_HRESETn = 1'b1;
		tb_HSEL = 1'b1;
		tb_HREADY = 1'b0;
		tb_HADDR = 32'd0;
		tb_HTRANS = 2'b10;
		tb_HWRITE = 1'b1;
		tb_HSIZE = 2'b00;
		tb_HWDATA = 68'd0;
		brightness_value = 4'b0100;
		set_out_image_borders;
		load_image;
		
		// Wait for some time before starting test cases
		#(1ns);
		
		// Test Case 1: Reset the top level module without asserting HREADY
		test_num = test_num + 1;
		reset_dut;
		$display("Test Case 1: Output after reset");
		expected_HREADYOUT = 1'b0;
		expected_HRDATA = 68'd0;
		@(posedge tb_HCLK)
		@(posedge tb_HCLK)
		check_outputs;

		// Test Case 1: Write one pixel buffer to the DUT and asset data ready
		test_num = test_num + 1;
		reset_dut;
		$display("Test Case 2: Output after one write");
		expected_HREADYOUT = 1'b1;
		expected_HRDATA = 68'd0;
		set_HWDATA(0, 0);
		tb_HWRITE = 1'b1;
		tb_HREADY = 1'b1;
		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;
		end
		check_outputs;

		test_num = test_num + 1;
		$display("Test Case 3: Read four output pixels from module");
		expected_HREADYOUT = 1'b1;
		expected_HRDATA = {64'd0, 4'b0100};
		tb_HWRITE = 1'b0;
		@(posedge tb_HCLK);
		tb_HREADY = 1'b1;
		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;
		end
		store_pixel(tb_HRDATA[3:0]);

		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;
		end
		store_pixel(tb_HRDATA[3:0]);

		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;
		end
		store_pixel(tb_HRDATA[3:0]);

		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;

		end
		store_pixel(tb_HRDATA[3:0]);
		check_outputs;
		
		set_HWDATA(0,2);
		tb_HWRITE = 1'b1;
		tb_HREADY = 1'b1;
		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;
		end
		check_outputs;

		tb_HWRITE = 1'b0;
		@(posedge tb_HCLK);
		tb_HREADY = 1'b1;
		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;
		end
		store_pixel(tb_HRDATA[3:0]);

		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;
		end
		store_pixel(tb_HRDATA[3:0]);

		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;
		end
		store_pixel(tb_HRDATA[3:0]);

		while(!tb_HREADYOUT)
		begin
			@(posedge tb_HCLK);
			tb_HREADY = 1'b0;

		end
		store_pixel(tb_HRDATA[3:0]);
		check_outputs;
		for(i = 0; i < 6; i++)
		begin
			for(j = 0; j < 6; j++)
			begin
				$display("Image[%d][%d]: %d", i, j, image[i][j]);
			end
		end
		/**for(i = 0; i < 298; i = i + 2)
		begin
			for(j = 0; j < 398; j = j + 2)
			begin
				set_HWDATA(i, j);
				tb_HWRITE = 1'b1;
				tb_HREADY = 1'b1;
				while(!tb_HREADYOUT)
				begin
					@(posedge tb_HCLK);
					tb_HREADY = 1'b0;
				end

				tb_HWRITE = 1'b0;
				@(posedge tb_HCLK);
				tb_HREADY = 1'b1;
				for(q = 0; q < 4; q++)
				begin
					while(!tb_HREADYOUT)
					begin
						@(posedge tb_HCLK);
						tb_HREADY = 1'b0;
					end
					store_pixel(tb_HRDATA[3:0]);
				end
			end
		end
		$display("Image written into memory.");**/
	end
endmodule;