// $Id: $
// File name:   tb_y_conv.sv
// Created:     12/6/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Y Convultion Block.

`timescale 1ns / 100ps

module tb_y_conv();
	
	parameter		INPUT_FILENAME		= "./docs/YConvInput.txt";
	parameter		INPUT_EXPECTED_FILENAME = "./docs/YConvExpected.txt";
	
	// Txt file based parameters
	localparam IMG_HEIGHT			= 9;	
	localparam IMG_WIDTH			= 9;
	localparam BITS_PER_PIXEL		= 4;

	// Define timing constants
	localparam CHECK_DELAY	= 1ns;
	localparam CLK_PERIOD	= 10ns;
	
	
	// Test bench dut port signals
	reg tb_clk;
	reg tb_n_rst;
	reg tb_calc_enable;
	reg [2:0][2:0][3:0] tb_pixels;
	reg [2:0][2:0][4:0] tb_filter;
	reg tb_calc_done;
	reg [9:0] tb_conv;
	
	// Declare Test Bench Variables						// temp variable for read/writing bytes from/to files
	reg [IMG_HEIGHT-1:0][IMG_WIDTH-1:0][3:0] image;
	integer expected_array[35:0];
	reg [2:0][2:0][4:0] base_filter;
	reg [9:0] expected_conv;
	reg expected_calc_done;
	integer test_num = 0;
	integer error_count = 0;
	integer in_file;							// Input file handle					
	integer i;
	integer j;										// Loop variable for misc. for loops
	integer k;
	integer m;
	integer n;

	task setup_base_filter;
	begin

		base_filter[0][0] = 5'b00001;
		base_filter[0][1] = 5'b00010;
		base_filter[0][2] = 5'b00001;
		base_filter[1][0] = 5'b00000;
		base_filter[1][1] = 5'b00000;
		base_filter[1][2] = 5'b00000;
		base_filter[2][0] = 5'b11111;
		base_filter[2][1] = 5'b11110;
		base_filter[2][2] = 5'b11111;
		tb_filter = base_filter;
	end
	endtask

	task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronize with clock)
		tb_n_rst = 1'b0;
		
		// Wait for a couple clock cycles
		@(posedge tb_clk);
		@(posedge tb_clk);
		
		// Release the reset
		@(negedge tb_clk);
		tb_n_rst = 1;
		
		// Wait for a while before activating the design
		@(posedge tb_clk);
		@(posedge tb_clk);
	end
	endtask
	
	// Clock gen block
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
	end
	
	// DUT portmap
	y_conv YCONV(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.calc_enable(tb_calc_enable),
	.pixels(tb_pixels),
	.filter(tb_filter),
	.calc_done(tb_calc_done),
	.conv(tb_conv)
	);
		

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

	task load_expected;
	begin
		in_file = $fopen(INPUT_EXPECTED_FILENAME, "r");
		for(i = 0; i < 36; i++)
		begin
			$fscanf(in_file, "%d ", expected_array[i]);
		end
		$fclose(in_file);
	end
	endtask

	task set_filter;
		input [3:0] brightness;
	begin
		tb_filter[0][1] = base_filter[0][1] * brightness;
		tb_filter[2][1] = base_filter[2][1] * brightness;
	end
	endtask 

	task set_expected;
		input integer index;
	begin
		expected_conv = expected_array[index];
	end
	endtask

	task check_outputs;
	begin
		#CHECK_DELAY
		if(expected_conv == tb_conv)
		begin
			$display("Correct value of %d for tb_conv", expected_conv);
		end
		else
		begin
			$error("Incorrect value of %d for tb_conv Expected Value of %d", tb_conv, expected_conv);
			error_count = error_count + 1;
		end

		if(expected_calc_done == tb_calc_done)
		begin
			$display("Correct value of %d for tb_calc_done", expected_calc_done);
		end
		else
		begin
			$error("Incorrect value of %d for tb_calc_done", tb_calc_done);
			error_count = error_count + 1;
		end
	end
	endtask	

	task set_pixels;
		input integer r;
		input integer c;
	begin
		for(i = r; i < r+3; i++)
		begin
			for(j = c; j < c+3; j++)
			begin
				tb_pixels[i-r][j-c] = image[i][j];
			end
		end
	end
	endtask

	// Test bench process
	initial
	begin
		// Initial values
		setup_base_filter;
		load_expected;
		set_filter(4'b0010);
		load_image;
		tb_n_rst = 1'b1;
		
		// Wait for some time before starting test cases
		#(1ns);
		
		// Test Case 1: Reset the buffer
		test_num = test_num + 1;
		reset_dut;
		$display("Test Case 1: Output after reset");
		expected_conv = 10'b0;
		expected_calc_done = 1'b0;
		check_outputs;
		
		//Test Case 2: output of Convolution Block with calc_enable low 
		test_num = test_num + 1;
		set_pixels(3, 3);
		$display("Test Case 2: Output long time after reset with low calc_enable");
		expected_conv = 'b0;
		expected_calc_done = 1'b0;
		@(posedge tb_clk)
		@(posedge tb_clk)
		@(posedge tb_clk)
		@(posedge tb_clk)
		check_outputs;
	
		//Test Case 3: output after reset with toggling load_enable
		test_num = test_num + 1;
		set_pixels(3, 0);
		$display("Test Case 3: Output after 3 clock cycles of high calc enbale");
		expected_conv = 10'd0;
		expected_calc_done = 1'b0;
		tb_calc_enable = 1'b1;
		@(posedge tb_clk)
		@(posedge tb_clk)
		@(posedge tb_clk)
		tb_calc_enable = 1'b0;
		check_outputs;

		reset_dut;

		//Test Cases 4-40: output for brightness values of 1, 2, 3, and 4
		for(k = 0; k < 4; k++)
		begin
			set_filter(k+1);
			for(m = 0; m < 3; m++)
			begin
				for(n = 0; n < 3; n++)
				begin
					test_num = test_num + 1;
					$display("Test Case %d: ", test_num);
					set_pixels(3*m, 3*n);
					set_expected(9*k + 3*m + n);
					expected_calc_done = 1'b1;
					@(posedge tb_clk)
					@(posedge tb_clk)
					tb_calc_enable = 1'b1;
					@(posedge tb_clk)
					tb_calc_enable = 1'b0;
					@(posedge tb_clk)
					@(posedge tb_clk)
					@(posedge tb_clk)
					@(posedge tb_clk)
					@(posedge tb_clk)
					@(posedge tb_clk)
					check_outputs;
				end
			end
		end
	end
endmodule;