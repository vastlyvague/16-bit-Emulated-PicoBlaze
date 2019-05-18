`timescale 1ns / 1ps

module baud_dec_tb;

	// Inputs
	reg [3:0] baud_mode;

	// Outputs
	wire [19:0] baud_rate;

	// Instantiate the Unit Under Test (UUT)
	baud_dec uut (
		.baud_mode(baud_mode), 
		.baud_rate(baud_rate)
	);

	initial begin
		// Initialize Inputs
		baud_mode = 0;

		// Wait 100 ns for global reset to finish
		#5
      baud_mode = 1;
      #5
      baud_mode = 2;
      #5
      baud_mode = 3;
      #5
      baud_mode = 4;
      #5
      baud_mode = 5;
      #5
      baud_mode = 6;      
      #5
      baud_mode = 7;
      #5
      baud_mode = 8;
      #5
      baud_mode = 9;
      #5
      baud_mode = 10;
      #5
      baud_mode = 11;
      #5;
   $finish;
	end
      
endmodule

