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
module SR_flop(clk, rst_sync, reset, set, interrupt);
   input      clk, rst_sync, reset, set;
   output     interrupt;
   reg        intr;
   
   always@(posedge clk, posedge rst_sync)
      if(rst_sync)
         intr <= 1'b0;
      else
         case({reset, set})
            {1'b0, 1'b0}: intr <= intr;
            {1'b0, 1'b1}: intr <= 1'b1;
            {1'b1, 1'b0}: intr <= 1'b0;
            {1'b1, 1'b1}: intr <= 1'bx;
            default:      intr <= intr;
         endcase
         
   assign interrupt = reset ? 1'b0 : intr;

endmodule
