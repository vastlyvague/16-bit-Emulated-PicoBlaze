`timescale 1ns / 1ps
//****************************************************************//
//  File name: addr_dec.v                                         //
//                                                                //
//  Created by       Thomas Nguyen on 2/22/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module addr_dec(s, EN, strobe, wr);

input            EN, strobe;
input      [2:0] s;
output reg [7:0] wr;

always@(*) begin
   wr = 8'b0;
   case(EN)
       1'b1  : wr[s] = strobe;
      default: wr = wr;
   endcase
   end

endmodule
