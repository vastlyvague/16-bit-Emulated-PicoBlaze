`timescale 1ns / 1ps
//****************************************************************//
//  File name: addr_dec.v                                         //
//                                                                //
//  Created by       Thomas Nguyen on 4/08/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module addr_dec(portid, ws, rs, wr, rd);

   input             ws, rs;
   input      [15:0] portid;
   output reg [15:0] wr, rd;

   always@(*) begin
      wr = 16'b0;
      rd = 16'b0;
   if(~portid[15]) begin
         wr[portid[2:0]] = ws;
         rd[portid[2:0]] = rs;
      end
      else begin
         wr = wr;
         rd = rd;
      end
   end

endmodule
