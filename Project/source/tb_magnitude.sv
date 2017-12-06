// $Id: $
// File name:   tb_magnitude.sv
// Created:     12/5/2017
// Author:      Michael Karrs
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for the Magnitude Functional Block.

module tb_magnitude();

	// Define local constants
	localparam CHECK_DELAY	= 1ns;
	localparam CLK_PERIOD	= 10ns;
	
	
	// Test bench dut port signals
	reg tb_clk;
	reg tb_n_rst;
	reg tb_calc_done;
	reg [9:0] tb_gx;
	reg [9:0] tb_gy;
	reg [3:0] tb_pixel;
	
	// Declare Test Bench Variables
	integer test_num = 0;
	integer error_count = 0;
	reg [3:0] expected_output;
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
									.calc_done(tb_calc_done),
									.gx(tb_gx),
									.gy(tb_gy),
									.pixel(tb_pixel)
								);
		

	task check_outputs;
	begin
		#CHECK_DELAY
		if(expected_output == tb_pixel)
		begin
			$display("Test Case %d: Correct Output of: %d", test_num, tb_pixel);
		end
		else
		begin
			$error("Test Case %d: Incorrect Output of: %d Expected Output of: %d", test_num, tb_pixel, expected_output);
			error_count = error_count + 1;
		end
	end
	endtask	

	// Test bench process
	initial
	begin
		// Initial values
		tb_n_rst = 1'b1;
		tb_gx = 10'd64;
		tb_gy = 10'd64;
		
		// Wait for some time before starting test cases
		#(1ns);
		
		// Test Case 1: Reset the magnitude block
		$display("Test Case 1: Output after reset");
		test_num = test_num + 1;
		reset_dut;
		expected_output = 'b0;
		check_outputs;
		
		//Test Case 2: output with gx = 0 and gy = 0
		$display("Test Case 2: Output with gx = 0 and gy = 0, long time after a reset");
		test_num = test_num + 1;
		tb_gx = 0;
		tb_gy = 0;
		expected_output = 'b0;
		@(posedge tb_clk)
		@(posedge tb_clk)
		@(posedge tb_clk)
		@(posedge tb_clk)
		check_outputs;
	
		//Test Case 3: output when gx = 64 and gy = 64
		$display("Test Case 3: Output with gx = 64 gy = 64");
		test_num = test_num + 1;
		tb_gx = 10'd64;
		tb_gy = 10'd64;
		expected_output = 4'b0011;
		@(posedge tb_clk)
		@(posedge tb_clk)
		@(posedge tb_clk)
		check_outputs;

		//Test Case 4: output when gx = 270 and gy = 270
		$display("Test Case 4: Output with max gx and gy value.");
		test_num = test_num + 1;
		tb_gx = 10'd270;
		tb_gy = 10'd270;
		expected_output = 4'b1111;
		@(posedge tb_clk)
		@(posedge tb_clk)
		@(posedge tb_clk)
		check_outputs;

		//Test Case 5: output when gx = -270 and gy = -270
		$display("Test Case 4: Output with max gx and gy value.");
		test_num = test_num + 1;
		tb_gx = 10'b1011110010;
		tb_gy = 10'b1011110010;
		expected_output = 4'b1111;
		@(posedge tb_clk)
		@(posedge tb_clk)
		@(posedge tb_clk)
		check_outputs;

		//Test Case 5: output when gx = -270 and gy = -270
		$display("Test Case 4: Output with max gx and gy value.");
		test_num = test_num + 1;
		tb_gx = 10'b1011110010;
		tb_gy = 10'b1011110010;
		expected_output = 4'b1111;
		@(posedge tb_clk)
		@(posedge tb_clk)
		@(posedge tb_clk)
		check_outputs;


	end
endmodule