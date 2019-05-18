`timescale 1ns / 100ps
module RXD_tb;

	// Inputs
	reg        clk, reset, btu, start, bit8, 
              pen, ohel, done, SDI, read;

	// Outputs
	wire       rxrdy, perr, ferr, ovf;
   wire [7:0] toTB;

	// Instantiate the Unit Under Test (UUT)
	rx_datapath uut (
		.clk(clk), .reset(reset), .btu(btu), .start(start), 
		.bit8(bit8), .pen(pen), .ohel(ohel), .done(done), 
		.SDI(SDI), .rxrdy(rxrdy), .perr(perr), .ferr(ferr), 
		.ovf(ovf), .read(read), .toTB(toTB));

   //Every time unit 5 is equal to 5 ns
   always #5 clk = ~clk;
   
	initial begin
		// Initialize Inputs
		{clk, reset} = 2'b0_0;
		{btu, start, done} = 3'b0_0_0;
		{bit8, pen, ohel} = 3'b1_1_0;
		SDI = 0;

      //Format how time is displayed and sets it to display in nanoseconds.
      $timeformat(-9, 1, " ns", 9);
      
      @(negedge clk)
         reset = 1'b1;
      @(negedge clk)
         reset = 1'b0;
      //rxrdy_t;
      //perr_t;
      //ferr_t;
      //ovf_t;
      @(negedge clk)
            {bit8, pen, ohel} = 3'b0_0_0;
            uut.shift_reg = 10'b11_0101_1100;
      @(negedge clk)
            {bit8, pen, ohel} = 3'b1_0_0;
            uut.shift_reg = 10'b11_0101_1100;
      @(negedge clk)
            {bit8, pen, ohel} = 3'b1_1_0;
            uut.shift_reg = 10'b11_0101_1100;
      @(negedge clk);
      $finish;
	end

   //reusuable code to test status flag registers
   task rxrdy_t;
      begin
         @(posedge clk)
            #1 $display("Testing RXRDY");
         @(negedge clk)
            {done, read} = 2'b10;
         @(negedge clk)
            {done, read} = 2'b00;
         @(negedge clk)
            {done, read} = 2'b01;
         @(negedge clk)
            {done, read} = 2'b10;
         $stop;
      end
   endtask;
   
   task perr_t;
      begin
         @(posedge clk)
            #1 $display("Testing PERR");
         @(negedge clk)
            uut.remap = 10'b11_0101_1100;
         @(negedge clk)
            {done, read} = 2'b10;
         @(negedge clk)
            {done, read} = 2'b00;
         @(negedge clk)
            {done, read} = 2'b01;
         @(negedge clk)
            uut.remap = 10'b10_0101_1100;
         @(negedge clk)
            {done, read} = 2'b10;
         $stop;
      end
   endtask;
   
   task ferr_t;
      begin
         @(posedge clk)
            #1 $display("Testing FERR");
         @(negedge clk)
            uut.remap = 10'b00_0101_1100;
         @(negedge clk)
            {done, read} = 2'b10;
         @(negedge clk)
            {done, read} = 2'b00;
         @(negedge clk)
            {done, read} = 2'b01;
         @(negedge clk)
            uut.remap = 10'b10_0101_1100;
         @(negedge clk)
            {done, read} = 2'b10;
         $stop;
      end
   endtask;
   
   task ovf_t;
      begin
         @(posedge clk)
            #1 $display("Testing OVF");
         @(negedge clk)
            {done, read} = 2'b10;
         repeat(4) @(negedge clk);
         @(negedge clk)
            {done, read} = 2'b11;
         @(negedge clk)
            {done, read} = 2'b00;
         $stop;
      end
   endtask;
endmodule

