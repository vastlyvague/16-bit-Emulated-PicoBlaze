`timescale 1ns / 1ps

module ped_tb;

	// Inputs
	reg clk;
	reg reset;
	reg INC_db_in;

	// Outputs
	wire POS_detect;

	// Instantiate the Unit Under Test (UUT)
	posedge_detect uut (
		.clk(clk), 
		.reset(reset), 
		.INC_db_in(INC_db_in), 
		.POS_detect(POS_detect)
	);
   always #5 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		INC_db_in = 0;

		@(negedge clk)
      reset = 1;
		@(negedge clk)
      reset = 0;
      INC_db_in = 1;
      
	end
      
endmodule

