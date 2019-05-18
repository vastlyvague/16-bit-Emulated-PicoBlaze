`timescale 1ns / 1ps
//****************************************************************//
//  File name: LD_reg.v                                           //
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
module LD_reg(clk, reset, ld, d, q);

   input            clk, reset, ld;
   input      [7:0] d;
   output reg [7:0] q;

   //Sequential Block. If load is set, output gets input else stays the same
   always@(posedge clk, posedge reset)
      if(reset)    q <= 8'b0;
      else if(ld)  q <= d;
      else         q <= q;

endmodule
