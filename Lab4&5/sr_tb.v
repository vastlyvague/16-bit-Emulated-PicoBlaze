`timescale 1ns / 1ps

module sr_tb;

	// Inputs
	reg clk;
	reg rst_sync;
	reg reset;
	reg set;

	// Outputs
	wire interrupt;

	// Instantiate the Unit Under Test (UUT)
	SR_flop uut (
		.clk(clk), 
		.rst_sync(rst_sync), 
		.reset(reset), 
		.set(set), 
		.interrupt(interrupt)
	);
   always #5 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst_sync = 0;
		reset = 0;
		set = 0;
      @(negedge clk)
      rst_sync = 1;
      @(negedge clk)
      rst_sync = 0;
      set = 1;
      @(negedge clk)
      rst_sync = 0;
      set = 0;
      @(negedge clk)
      rst_sync = 0;
      reset = 1;
      @(negedge clk)
      rst_sync = 0;
      reset = 1;
      set = 1;
      @(negedge clk)
      rst_sync = 0;
      reset = 0;
      set = 0;
   $finish;
	end
      
endmodule

