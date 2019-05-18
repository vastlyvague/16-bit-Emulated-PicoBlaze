`timescale 1ns / 100ps
//****************************************************************//
//  File name: top_level_tb.v                                     //
//                                                                //
//  Created by       Thomas Nguyen on 2/28/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module top_level_tb;

	// Inputs
	reg         clk, reset, bit8, pen, ohel;
	reg   [3:0] baudm;
   reg  [10:0] transmitted;

	// Outputs
   wire        uart_rxd_out;
   wire [15:0] leds;
   
   integer     i, j, k;

	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk100mhz(clk), 
		.reset(reset), 
		.baudm(baudm), 
		.bit8(bit8), 
		.pen(pen), 
		.ohel(ohel), 
		.uart_rxd_out(uart_rxd_out),
      .leds(leds)
	);

   //Every time unit 5 is equal to 5 ns
   always #5 clk = ~clk;
      
	initial begin
		// Initialize Inputs
		clk = 0;	
      reset = 0;
      baudm = 4'b0;
      {bit8, pen, ohel} = 3'b0_0_0;
      
      k = 0;
      
      //Format how time is displayed and sets it to display in nanoseconds.
      $timeformat(-9, 1, " ns", 9);
      
      $display("-----------------------------------------------------------------");
      $display("CECS 460 Lab 2: Top Level Test Bench ");
      $display("-----------------------------------------------------------------");
      $display(" ");
      
      @(negedge clk)
         reset = 1;
      @(negedge clk)
         reset = 0;
      @(negedge clk)
         baudm = 4'b0; //Fastest Baud Rate Mode
         
      @(posedge clk)
         #1 $display("LEDs = %b_%b", leds[15:8], leds[7:0]);

      @(negedge uut.uut2.btu) begin
         transmitted[k] = uart_rxd_out;
         k = k + 1;
         end
      //Call reusable task
      display_tx;      
      $finish;
	end
   
   task display_tx;
      @(posedge uut.uut2.txrdy) begin
         #1 $display("Serial Data Transmitted = %b", transmitted);
            $display("Data Transmitted        = %b", transmitted[7:1]);
      end
   endtask;
      
endmodule

