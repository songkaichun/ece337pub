// $Id: $
// File name:   tb_magnitude.sv
// Created:     12/5/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for the Magnitude Functional Block.
module tb_magnitude();

	// Define local constants
	localparam CHECK_DELAY	= 4ns;
	localparam CLK_PERIOD	= 10ns;
	
	
	// Test bench dut port signals
	reg tb_clk;
	reg tb_n_rst;
	reg [9:0] tb_gx;
	reg [9:0] tb_gy;
	reg tb_calc_done;
	reg [3:0] tb_pixel;
	reg tb_output_enable;
	
	// Declare Test Bench Variables
	integer test_num = 0;
	integer error_count = 0;
	reg [3:0] expected_output;
	reg expected_output_enable;
	int sum;
	integer i;
	integer j;										// Loop variable for misc. for loops
	
	
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
	magnitude MAG(
									.clk(tb_clk),
									.n_rst(tb_n_rst),
									.gx(tb_gx),
									.gy(tb_gy),
									.calc_done(tb_calc_done),
									.pixel(tb_pixel),
									.output_enable(tb_output_enable)
								);
		

	task check_outputs;
	begin
		#CHECK_DELAY
		if(expected_output == tb_pixel || expected_output-1 == tb_pixel || expected_output+1 == tb_pixel)
		begin
			$display("Test Case %d: Correct Output of: %d", test_num, tb_pixel);
		end
		else
		begin
			$error("Test Case %d: Incorrect Output of: %d Expected Output of: %d", test_num, tb_pixel, expected_output);
			error_count = error_count + 1;
		end

		if(expected_output_enable == tb_output_enable)
		begin
			$display("Test Case %d: Correct output_enable of: %d", test_num, tb_output_enable);
		end
		else
		begin
			$error("Test Case %d: Incorrect output_enable of: %d Expected Output of: %d", test_num, tb_output_enable, expected_output_enable);
			error_count = error_count + 1;
		end
	end
	endtask	

	// Test bench process
	initial
	begin
		// Initial values
		tb_n_rst = 1'b1;
		tb_gx = 10'd0;
		tb_gy = 10'd0;
		tb_calc_done = 1'b0;
		
		// Wait for some time before starting test cases
		#(1ns);
		
		// Test Case 1: Reset the magnitude block
		$display("Test Case 1: Output after reset");
		test_num = test_num + 1;
		reset_dut;
		expected_output = 'b0;
		expected_output_enable = 1'b0;
		check_outputs;
		
		//Test Case 2: output with gx = 0 and gy = 0
		$display("Test Case 2: Output with gx = 0 and gy = 0, long time after a reset");
		test_num = test_num + 1;
		tb_gx = 0;
		tb_gy = 0;
		tb_calc_done = 1'b1;
		expected_output = 'b0;
		expected_output_enable =1'b1; 
		@(posedge tb_clk)
		#(1ns);
		tb_calc_done = 1'b0;
		@(posedge tb_clk)
		check_outputs;
	
		//Test Case 3: output when gx = 64 and gy = 64
		$display("Test Case 3: Output with gx = 64 gy = 64");
		test_num = test_num + 1;
		tb_gx = 10'd64;
		tb_gy = 10'd64;
		tb_calc_done = 1'b1;
		expected_output = 4'b1010;
		expected_output_enable = 1'b1;
		@(posedge tb_clk)
		#(1ns);
		tb_calc_done = 1'b0;
		@(posedge tb_clk)
		check_outputs;

		//Test Case 4: output when gx = 150 and gy = 150
		$display("Test Case 4: Output with max gx and gy value.");
		test_num = test_num + 1;
		tb_gx = 10'd150;
		tb_gy = 10'd150;
		tb_calc_done = 1'b1;
		expected_output = 4'b1111;
		expected_output_enable = 1'b1;
		@(posedge tb_clk)
		#(1ns);
		tb_calc_done = 1'b0;
		@(posedge tb_clk)
		check_outputs;

		//Test Case 5: output when gx = -150 and gy = -150
		$display("Test Case 5: Output with max gx and gy value.");
		test_num = test_num + 1;
		tb_gx = 10'b1101101010;
		tb_gy = 10'b1101101010;
		tb_calc_done = 1'b1;
		expected_output = 4'b1111;
		expected_output_enable = 1'b1;
		@(posedge tb_clk)
		#(1ns);
		tb_calc_done = 1'b0;
		@(posedge tb_clk)
		check_outputs;

		for(i = -150; i < 151; i++)
		begin
			for(j = -150; j < 151; j++)
			begin
				test_num = test_num+1;
				tb_gx = i;
				tb_gy = j;
				tb_calc_done = 1'b1;
				#(1ns)
				sum = (i/16)*(i/16) + (j/16)*(j/16);
				if(sum >= 0 && sum < 3)
					expected_output = 4'b0000;
				else if(sum < 6)
					expected_output = 4'b0001;
				else if(sum < 9)
					expected_output = 4'b0001;
				else if(sum < 12)
					expected_output = 4'b0010;
				else if(sum < 15)
					expected_output = 4'b0011;
				else if(sum < 18)
					expected_output = 4'b0100;
				else if(sum < 21)
					expected_output = 4'b0101;
				else if(sum < 24)
					expected_output = 4'b0110;
				else if(sum < 27)
					expected_output = 4'b0111;
				else if(sum < 30)
					expected_output = 4'b1000;
				else if(sum < 33)
					expected_output = 4'b1001;
				else if(sum < 36)
					expected_output = 4'b1010;
				else if(sum < 39)
					expected_output = 4'b1011;
				else if(sum < 42)
					expected_output = 4'b1100;
				else if(sum < 45)
					expected_output = 4'b1101;
				else if(sum < 48)
					expected_output = 4'b1110;
				else
					expected_output = 4'b1111;
				@(posedge tb_clk)
				#(1ns);
				tb_calc_done = 1'b0;
				@(posedge tb_clk)
				check_outputs;
			end
		end

	end
endmodule