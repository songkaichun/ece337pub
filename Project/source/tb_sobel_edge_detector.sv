// $Id: $
// File name:   tb_sobel_edge_detector.sv
// Created:     12/6/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Top Level Sobel Edge Detector.
module tb_sobel_edge_detector();
	parameter		INPUT_FILENAME		= "./docs/400x300Test.txt";
	parameter		OUTPUT_FILENAME		= "./docs/400x300OUT.txt";
	
	// Txt file based parameters
	localparam IMG_HEIGHT			= 300;	
	localparam IMG_WIDTH			= 400;
	localparam BITS_PER_PIXEL		=4;

	// Define local constants
	localparam NUM_VAL_BITS	= 16;
	localparam MAX_VAL_BIT	= NUM_VAL_BITS - 1;
	localparam CHECK_DELAY	= 1ns;
	localparam CLK_PERIOD	= 10ns;
	
	
	// Test bench dut port signals
	reg tb_clk;
	reg tb_n_rst;
	reg tb_bus_data_ready;
	reg [3:0] tb_brightness_value;
	reg [3:0][3:0][3:0] tb_input_pixels;
	reg [3:0] tb_output_pixel;
	reg tb_output_enable;
	reg tb_need_data;
	
	// Declare Test Bench Variables					
	reg [IMG_HEIGHT:0][IMG_WIDTH:0][3:0] image;
	reg [IMG_HEIGHT:0][IMG_WIDTH:0][3:0] out_image;
	reg [3:0] expected_output;
	reg expected_output_enable;
	integer test_num = 0;
	integer error_count = 0;
	integer in_file;							// Input file handle
	integer out_file;							// Result file handle
	integer i;
	integer j;								// Loop variable for misc. for loops
	integer m;
	integer n;
	integer q;
	integer r;
	
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
	sobel_edge_detector SOBEL(
									.clk(tb_clk),
									.n_rst(tb_n_rst),
									.bus_data_ready(tb_bus_data_ready),
									.brightness_value(tb_brightness_value),
									.input_pixels(tb_input_pixels),
									.output_pixel(tb_output_pixel),
									.output_enable(tb_output_enable),
									.need_data(tb_need_data)
								);
		
	task set_pixels;
		input integer r;
		input integer c;
	begin
		for(i = r; i < r+3; i++)
		begin
			for(j = c; j < c+3; j++)
			begin
				tb_input_pixels[i-r][j-c] = image[i][j];
			end
		end
	end
	endtask

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

	task check_outputs;
	begin
		#CHECK_DELAY
		if(expected_output == tb_output_pixel)
		begin
			$display("Correct value of %d for output_pixel", expected_output);
		end
		else
		begin
			$error("Incorrect value of %d for output_pixel\nExpected Value of %d", tb_output_pixel, expected_output);
			error_count = error_count + 1;
		end
		if(expected_output_enable == tb_output_enable)
		begin
			$display("Correct value of %d for output_enable", expected_output_enable);
		end
		else
		begin
			$error("Incorrect value of %d for output_enable\nExpected Value of %d", tb_output_enable, expected_output_enable);
			error_count = error_count + 1;
		end
	end
	endtask	
	// Test bench process
	initial
	begin
		// Initial values
		tb_n_rst = 1'b1;
		tb_bus_data_ready = 1'b0;
		tb_brightness_value = 4'b0001;
		set_pixels(0, 0);
		set_out_image_borders;
		load_image;
		
		// Wait for some time before starting test cases
		#(1ns);
		
		// Test Case 1: Reset the buffer
		test_num = test_num + 1;
		reset_dut;
		$display("Test Case 1: Output after reset");
		expected_output_enable = 1'b0;
		expected_output = 4'b0000;
		check_outputs;
		

		m = 0;
		n = 0;
		q = 0;
		while(m < IMG_HEIGHT-3)
		begin
			while(n < IMG_WIDTH-3)
			begin
				if(tb_output_enable == 1'b1)
				begin
					if(q == 0)
					begin
						out_image[m+1][n+1] = tb_output_pixel;
					end
					else if(q == 1)
					begin
						out_image[m+1][n+2] = tb_output_pixel;
					end
					else if(q == 2)
					begin
						out_image[m+2][n+1] = tb_output_pixel;
					end
					else if(q == 3)	
					begin
						out_image[m+2][n+2] = tb_output_pixel;
					end
					q = q + 1;
				end
				if(tb_need_data == 1'b1)
				begin
					n = n + 2;
					set_pixels(m,n);
					tb_bus_data_ready = 1'b1;
					@(posedge tb_clk)
					tb_bus_data_ready = 1'b0;
				end
				@(posedge tb_clk);
			end
			q = 0;
			m = m + 2;
		end
		$display("out_image[0][0]: %d", out_image[0][0]);
		$display("out_image[0][1]: %d", out_image[0][1]);
		$display("out_image[0][2]: %d", out_image[0][2]);
		$display("out_image[1][0]: %d", out_image[1][0]);
		$display("out_image[1][1]: %d", out_image[1][1]);
		$display("out_image[1][2]: %d", out_image[1][2]);
		$display("out_image[2][0]: %d", out_image[2][0]);
		$display("out_image[2][1]: %d", out_image[2][1]);
		$display("out_image[2][2]: %d", out_image[2][2]);
	end
endmodule;