`timescale 1ns / 1ps
//****************************************************************// 
//  File name: pixel_controller.v                                 // 
//                                                                // 
//  Created by       Thomas Nguyen on 03/14/2018.                 // 
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          // 
//                                                                // 
//                                                                // 
//  In submitting this file for class work at CSULB               // 
//  I am confirming that this is my work and the work             // 
//  of no one else. In submitting this code I acknowledge that    // 
//  plagiarism in student project work is subject to dismissal.   //  
//  from the class                                                // 
//****************************************************************// 
// Description:    
// Instantiates the necessary verilog modules to make the display
// controller. Used to make the top-level module look less
// cluttered and controls the displaying of the 7 segment displays
////////////////////////////////////////////////////////////////////
module display_controller(
       clk, reset, seg0, seg1, seg2, seg3, seg4, seg5,
       seg6, seg7, an, ca, cb, cc, cd, ce, cf, cg
       );
   
   input        clk, reset;
   
   // 4 bit address/data input to 8 to 1 mux
   input  [3:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;
   
   // 7 segment display
   output [7:0] an;
   
   // cathodes for hex display
   output       ca, cb, cc, cd, ce, cf, cg;
   
   wire   [2:0] seg_sel;
   wire   [3:0] Y;
	wire         tick;
	reg   [17:0] i,d;     // counter variables
	
   // tick manipulator to get 480Hz
   assign tick = (i==20'd208_333);  //approx value for how many clks = 480Hz
   
   always @(*)
      if(tick) d = 18'b0; else
         d = i + 18'b1;
	always @(posedge clk or posedge reset)
		if(reset) i<=18'b0; else
         i<=d;
         
   //////////////////////////////////////////////////////
   pixel_controller  uut2(clk, reset, tick, an, seg_sel);
   
   ad_mux            uut3(Y, seg_sel, seg0, seg1, seg2, seg3,
                          seg4, seg5, seg6, seg7);
   
   Hex_to_7Seg       uut4(Y, ca, cb, cc, cd, ce, cf, cg);
   
endmodule
