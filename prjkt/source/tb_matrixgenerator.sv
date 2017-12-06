// $Id: $
// File name:   tb_matrixgenerator.sv
// Created:     12/4/2017
// Author:      Kaichun Song
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: tbmatrix
module tb_matrixgenerator
();

	// Define local parameters used by the test bench
	localparam NUM_INPUT_BITS			= 4;
	localparam NUM_OUTPUT_BITS		= 2*NUM_INPUT_BITS;
	localparam MAX_OUTPUT_BIT			= NUM_OUTPUT_BITS - 1;
	localparam NUM_TEST_BITS 			= NUM_INPUT_BITS * 2;
	localparam MAX_TEST_BIT				= NUM_TEST_BITS - 1;
	localparam NUM_TEST_CASES 		= 2 ** NUM_TEST_BITS;
	localparam MAX_TEST_VALUE 		= NUM_TEST_CASES - 1;
	localparam TEST_DELAY					= 10;
	
	// Declare Design Under Test (DUT) portmap signals
	wire	[3:0] bscalar;
	wire	[4:0] x [0:2][0:2];
	wire	[4:0] y [0:2][0:2] ;
	wire  [4:0] pixelx [0:2][0:2] ;
	wire  [4:0] pixely [0:2][0:2];
	// Declare test bench signals
	integer tb_test_case;
	byte tb_initial;
	reg [4:0] tb_test_inputs;
	
	assign pixelx = {{{5'b00001},{5'b00000},{5'b11111}},{{5'b00010},{5'b00000},{5'b11110}},{{5'b00001},{5'b00000},{5'b11111}}};
	assign pixely = {{{5'b00001},{5'b00010},{5'b00001}},{{5'b00000},{5'b00000},{5'b00000}},{{5'b11111},{5'b11110},{5'b11111}}};
	//assign x = pixelx;
	//assign y = pixely;
	assign bscalar = tb_test_inputs;
	// DUT port map
	matrixgenerator DUT(.bscalar(bscalar), .outx(x), .outy(y));
	
	initial
		begin
			// Initialize test inputs for DUT	
			tb_test_inputs = 0;
			tb_initial = 0;
			// Interative Exhaustive Testing Loop
			for(tb_test_case = 0; tb_test_case < 16; tb_test_case = tb_test_case + 1)
			begin
				// Send test input to the design
				tb_test_inputs = tb_initial;
				//bscalar = tb_initial;
				// Wait for a bit to allow this process to catch up with assign statements triggered
				// by test input assignment above
				#1;
				
				// Calculate the expected outputs
				
				// Wait for DUT to process the inputs
				#(TEST_DELAY - 1);
				
				// Check the DUT's Sum output value
				if(x[1][0] == tb_test_inputs * 2 && x[1][2] =={1,tb_test_inputs * 2 })
				begin
					$info("Correct Product value for xtest case %d!", tb_test_case);
				end
				else
				begin
					$error("Incorrect Product value for test case %d!", tb_test_case);
					$error("Expected: %d, Actual: %d", tb_test_inputs * 2, x[1][0]);
				end

				if(y[0][1] == tb_test_inputs * 2 && x[2][1] =={1, tb_test_inputs * 2})
				begin
					$info("Correct Product value for ytest case %d!", tb_test_case);
				end
				else
				begin
					$error("Incorrect Product value for ytest case %d!", tb_test_case);
					$error("Expected: %d, Actual: %d", bscalar * 2, y[0][1]);
				end
				tb_initial = tb_initial +1;
			end
		end
	final
	
	begin
		if(tb_test_case != 16)
		begin
			// Didn't run the test bench through all test cases
			$display("This test bench was not run long enough to execute all test cases. Please run this test bench for at least a total of %d ns", (NUM_TEST_CASES * TEST_DELAY));
		end
		else
		begin
			// Test bench was run to completion
			$display("This test bench has run to completion");
		end
	end
endmodule
