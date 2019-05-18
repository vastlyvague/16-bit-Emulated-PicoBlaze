`timescale 1ns / 1ps
module AISO_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire reset_sync;

	// Instantiate the Unit Under Test (UUT)
	AISO_register uut (
		.clk(clk), 
		.reset(reset), 
		.reset_sync(reset_sync)
	);

   always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		@(negedge clk)
         reset = 1;
      @(negedge clk)
         reset = 0;
	end
      
endmodule

