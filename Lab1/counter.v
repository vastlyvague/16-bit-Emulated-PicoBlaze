`timescale 1ns / 1ps
//****************************************************************// 
//  File name: counter.v                                          // 
//                                                                // 
//  Created by       Thomas Nguyen on 9/13/18    .                // 
//  Copyright c 2018 Thomas Nguyen. All rights reserved.          // 
//                                                                // 
//                                                                // 
//  In submitting this file for class work at CSULB               // 
//  I am confirming that this is my work and the work             // 
//  of no one else. In submitting this code I acknowledge that    // 
//  plagiarism in student project work is subject to dismissal.   //  
//  from the class                                                // 
//****************************************************************// 
/* Description: 
 *  A counter that checks for input from inc_p and uphdnl to either
 *  increment or decrement the output. If inc_p is a 0 then it
 *  doesn't do either and output gets itself.
 */
module counter(clk, reset, inc_p, uphdnl, q);
   input             clk, reset, inc_p, uphdnl;
   output reg [15:0] q;

   always@(posedge clk or posedge reset)
      if(reset) q<= 16'b0; else
         case({inc_p, uphdnl})
            2'b10: q<=q-16'b1;
            2'b11: q<=q+16'b1;
            default: q<=q;
         endcase
         
endmodule
