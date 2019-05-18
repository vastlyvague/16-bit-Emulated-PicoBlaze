`timescale 1ns / 100ps

module SOPC_CORE_tf;

	// Inputs
	reg clk;
	reg reset;
	reg [3:0] baudm;
	reg bit8;
	reg pen;
	reg ohel;
	reg uart_txd_in;

	// Outputs
	wire uart_rxd_out;
	wire [15:0] leds;
   
   reg  [0:0] mem [0:999_999];
   reg  [9:0] dataIn;
   integer i;
   
   

	// Instantiate the Unit Under Test (UUT)
	SOPC_CORE uut (
		.clk100mhz(clk), 
		.reset(reset), 
		.baudm(baudm), 
		.bit8(bit8), 
		.pen(pen), 
		.ohel(ohel), 
		.uart_txd_in(uart_txd_in), 
		.uart_rxd_out(uart_rxd_out), 
		.leds(leds)
	);
                  
   //Every time unit 5 is equal to 5 ns
   always #5 clk = ~clk;
   
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		baudm = 4'b1011; //fastest baud rate
		bit8 = 1;
		pen = 0;
		ohel = 0;
		uart_txd_in = 0;
      dataIn = 10'h2A;
      
      //Load contents of a .dat file into the vector
      $readmemb("TXOUT.dat", mem);
      
      //Format how time is displayed and sets it to display in nanoseconds.
      $timeformat(-9, 1, " ns", 9);
      @(negedge clk)
         reset = 1'b1;
      @(negedge clk)
         reset = 1'b0;
         
      for(i = 0; i < 100_000; i = i + 1) begin
         @(negedge clk)
            uart_txd_in = mem[i];
      end

      for(i = 0; i < 10; i = i + 1) begin
         @(negedge clk)
            uart_txd_in = 1'b0;
      end
      
      for(i = 0; i < 10; i = i + 1) begin
         @(negedge clk)
            uart_txd_in = dataIn[i];
      end

      @(negedge clk)
        uart_txd_in = 1'b0;
      #100_000;
      $finish;
	end
      
endmodule

