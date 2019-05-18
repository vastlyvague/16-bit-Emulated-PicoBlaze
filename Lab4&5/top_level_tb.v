`timescale 1ns / 1ps
module top_level_tb;

	// Inputs
	reg SYS_CLK;
	reg SYS_RST;
	reg i_RX;
	reg [7:0] i_SW;

	// Outputs
	wire o_TX;
	wire [15:0] o_LED;
   
	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.SYS_CLK(SYS_CLK), 
		.SYS_RST(SYS_RST), 
		.i_RX(i_RX), 
		.i_SW(i_SW), 
		.o_TX(o_TX), 
		.o_LED(o_LED)
	);

   always #5 SYS_CLK = ~SYS_CLK;
	initial begin
		// Initialize Inputs
		SYS_CLK = 0;
		SYS_RST = 1;
		i_RX = 1;
		i_SW = 7'b0;

		#100;
      @(negedge SYS_CLK)
         SYS_RST = 0;
         
      $finish;
	end
      
endmodule

