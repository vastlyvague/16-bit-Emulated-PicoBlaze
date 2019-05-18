`timescale 1ns / 1ps
module SOPC_CORE_tb;

	// Inputs
	reg clk100mhz;
	reg reset;
	reg [3:0] baudm;
	reg bit8;
	reg pen;
	reg ohel;
	reg uart_txd_in;

	// Outputs
	wire uart_rxd_out;
	wire [15:0] leds;
   integer i;
	reg [0:0] mem [0:999_999];
	
   // Instantiate the Unit Under Test (UUT)
   SOPC_CORE uut ( .clk100mhz(clk100mhz), .reset(reset), .baudm(baudm), 
                   .bit8(bit8), .pen(pen), .ohel(ohel),
                   .uart_txd_in(uart_txd_in), 
                   .uart_rxd_out(uart_rxd_out), .leds(leds));

   always #5 clk100mhz = ~clk100mhz;
   
	initial begin
		// Initialize Inputs
      clk100mhz = 0; reset = 1; baudm = 4'b1011;
      bit8 = 1;      pen = 0;   ohel = 0;
      uart_txd_in = 1;

		// Wait 100 ns for global reset to finish
		#100;
      @(negedge clk100mhz)
         reset = 0;
         
		$readmemb("TXOUT.dat", mem);
		for (i = 0; i<100_000; i = i + 1)begin
			@(negedge clk100mhz)
			uart_txd_in = 1'b1;
		end // for loop
      $finish;
	end
      
endmodule

