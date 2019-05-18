`timescale 1ns / 1ps
//****************************************************************// 
//  File name: top_level_tf.v                                     // 
//                                                                // 
//  Created by       Thomas Nguyen on 9/20/18    .                // 
//  Copyright c 2018 Thomas Nguyen. All rights reserved.          // 
//                                                                // 
//                                                                // 
//  In submitting this file for class work at CSULB               // 
//  I am confirming that this is my work and the work             // 
//  of no one else. In submitting this code I acknowledge that    // 
//  plagiarism in student project work is subject to dismissal.   //  
//  from the class                                                // 
//****************************************************************// 
module top_level_tf;
	reg          clk100mhz, reset, btn, uphdnl;
	wire   [7:0] an;
	wire   [6:0] ca;
   integer      i;

	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk100mhz(clk100mhz), .reset(reset), 
		.btn(btn), .uphdnl(uphdnl), 
		.an(an), .ca(ca)
	);
   
   always #5 clk100mhz = ~clk100mhz;
   
	initial begin
		// Initialize Inputs
		clk100mhz = 0;	reset = 1;	btn = 1;
		uphdnl = 0;

      #100;
      reset = 0;
      #10000000;
      // Add stimulus here
      for(i=0;i<3;i=i+1) begin
         btn = ~btn;
         #30000000;
      end

      uphdnl = ~uphdnl;

      for(i=0;i<8;i=i+1) begin
         btn = ~btn;
         #30000000;
      end
      $finish;
	end
      
endmodule

