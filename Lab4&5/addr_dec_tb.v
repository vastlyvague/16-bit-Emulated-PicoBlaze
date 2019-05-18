`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:44:50 05/11/2019
// Design Name:   addr_dec
// Module Name:   C:/Users/vshoot/Documents/CECS/cecs460/lab4/lab4/addr_dec_tb.v
// Project Name:  lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: addr_dec
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module addr_dec_tb;

	// Inputs
	reg [15:0] portid;
	reg ws;
	reg rs;

	// Outputs
	wire [15:0] wr;
	wire [15:0] rd;

   reg  clk;
	// Instantiate the Unit Under Test (UUT)
	addr_dec uut (
		.portid(portid), 
		.ws(ws), 
		.rs(rs), 
		.wr(wr), 
		.rd(rd)
	);
   
   always #5 clk = ~clk;
   
	initial begin
		clk = 0;
		portid = 0;
		ws = 0;
		rs = 0;

		#5
      ws = 1;
      portid = 16'h0000_0001;
      #5
      ws = 0;
      rs = 1;
      portid = 16'h8000_0002;
      #5
      ws = 0;
      rs = 0;
		// Add stimulus here

	end
      
endmodule

