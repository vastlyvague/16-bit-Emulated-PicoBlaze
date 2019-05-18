`timescale 1ns / 1ps
//****************************************************************//
//  File name: posedge_detect.v                                   //
//                                                                //
//  Created by       Thomas Nguyen on 09/20/2018.                 //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
//  Description:
//  A pulse maker that detects the first rising edge and generates
//  a one clock pulse
////////////////////////////////////////////////////////////////////
module posedge_detect(clk, reset, INC_db_in, POS_detect);
   input      clk, reset, INC_db_in;
   output     POS_detect;
   reg        q, d;
   
   always@(posedge clk or posedge reset)
      if(reset) begin
                  d <= 1'b0; 
                  q <= 1'b0; 
                end else begin
                  d <= INC_db_in;
                  q <= d;
                end
   
   assign POS_detect = ~q & d;
   
endmodule
