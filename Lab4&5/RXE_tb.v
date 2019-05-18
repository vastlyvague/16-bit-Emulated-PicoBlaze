`timescale 1ns / 100ps
//****************************************************************//
//  File name: RXE_tb.v                                           //
//                                                                //
//  Created by       Thomas Nguyen on 3/26/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module RXE_tb;
	reg clk, reset, rx, bit8, pen, ohel, read;
	reg [19:0] br;
	
	wire rxrdy, perr, ferr, ovf;
	wire [7:0] rx_out;
   
   integer i;

	// Instantiate the Unit Under Test (UUT)
	rx_engine uut (
		.clk(clk), .reset(reset), .rx(rx), .bit8(bit8), 
		.pen(pen), .ohel(ohel), .br(br), .rxrdy(rxrdy), 
		.perr(perr), .ferr(ferr), .ovf(ovf), .rx_out(rx_out), 
		.read(read)
	);
   
   //Every time unit 5 is equal to 5 ns
   always #5 clk = ~clk;

	initial begin		
      {clk, reset, rx} = 5'b0_0_0;
      {bit8, pen, ohel} = 3'b0_0_0;
      br = 20'd109; //fastest baudrate
		read = 0;
      //Format how time is displayed and sets it to display in nanoseconds.
      $timeformat(-9, 1, " ns", 9);
      
      @(negedge clk)
         reset = 1'b1;
      @(negedge clk) 
         begin
            {bit8, pen, ohel} = 3'b1_1_1;
            #1085;
            reset = 1'b0;
         end
      for(i = 0; i < 12; i = i + 1) begin
         #1085;
         rx = ~rx;
      end
      #4340;
      rx = ~rx;
      $stop;
	end
      
endmodule

