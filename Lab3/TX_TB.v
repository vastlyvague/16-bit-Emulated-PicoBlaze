`timescale 1ns / 100ps
module TX_TB;

	// Inputs
	reg        clk, reset, ld, bit8, pen, ohel;
	reg [19:0] baud_rate;
	reg  [7:0] out_port;

	// Outputs
	wire       tx;
	wire       txrdy;

   //To write to data file
   integer    f;
   reg        flip;
   time       t;
   
	// Instantiate the Unit Under Test (UUT)
	tx_engine uut (
		.clk(clk), .reset(reset), .ld(ld), .bit8(bit8), 
		.pen(pen), .ohel(ohel), .baud_rate(baud_rate), 
		.out_port(out_port), .tx(tx), 
		.txrdy(txrdy));
   
   //Every time unit 5 is equal to 5 ns
   always #5 clk = ~clk;
   
   //Generate bits of data, followed by a space
   always #t
      begin
         flip = ~flip;
         $fwrite(f, tx, " ");
      end
      
	initial begin
      f = $fopen("TXOUT.dat");
		{clk, reset} = 2'b00;
		ld = 0;
		bit8 = 0;
		pen = 0;
		ohel = 0;
		baud_rate = 20'd109;
		out_port = 8'h3a;
      t = 100;
      flip = 0;
      //Format how time is displayed and sets it to display in nanoseconds.
      $timeformat(-9, 1, " ns", 9);
      @(negedge clk)
         reset = 1'b1;
      @(negedge clk)
         reset = 1'b0;
      @(negedge clk)
         ld = 1'b1;
      @(negedge clk)
         ld = 1'b0;
      #100_000         
      $fclose(f);
      $finish;
	end
      
endmodule

