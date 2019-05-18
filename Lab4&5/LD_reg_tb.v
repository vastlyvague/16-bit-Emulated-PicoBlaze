`timescale 1ns / 1ps

module LD_reg_tb;

	// Inputs
	reg clk;
	reg reset;
	reg ld;
	reg [7:0] d;

	// Outputs
	wire [7:0] q;

	// Instantiate the Unit Under Test (UUT)
	LD_reg uut (
		.clk(clk), 
		.reset(reset), 
		.ld(ld), 
		.d(d), 
		.q(q)
	);

   always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		ld = 0;
		d = 0;
      @(negedge clk)
         reset = 1;
      @(negedge clk)
         reset = 0;
      d = 8'b1111_0000;
      @(negedge clk)
         ld = 1;
      @(negedge clk)
         ld = 0;
         d = 8'b0000_1111;
      $finish;
	end
      
endmodule

