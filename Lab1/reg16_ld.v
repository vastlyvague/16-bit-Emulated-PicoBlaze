`timescale 1ns / 1ps
//****************************************************************// 
//  File name: top_level.v                                        // 
//                                                                // 
//  Created by       Thomas Nguyen on 1/29/19.                    // 
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          // 
//                                                                // 
//                                                                // 
//  In submitting this file for class work at CSULB               // 
//  I am confirming that this is my work and the work             // 
//  of no one else. In submitting this code I acknowledge that    // 
//  plagiarism in student project work is subject to dismissal.   //  
//  from the class                                                // 
//****************************************************************// 
module reg16_ld(clk, reset, load, d, q);
input             clk, reset, load;
input      [15:0] d;
output reg [15:0] q;

always @(posedge clk, posedge reset)
   if(reset)
      q <= 15'h0;
   else if(load)
         q <= d;
      else
         q <= q;
         
endmodule
