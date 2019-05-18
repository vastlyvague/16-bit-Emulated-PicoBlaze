`timescale 1ns / 1ps
//****************************************************************// 
//  File name: Hex_to_7Seg.v                                      // 
//                                                                // 
//  Created by       Thomas Nguyen on 2/27/18    .                // 
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          // 
//                                                                // 
//                                                                // 
//  In submitting this file for class work at CSULB               // 
//  I am confirming that this is my work and the work             // 
//  of no one else. In submitting this code I acknowledge that    // 
//  plagiarism in student project work is subject to dismissal.   //  
//  from the class                                                // 
//****************************************************************// 
 /* Purpose: This module displays the present state of the machine in hex.
 *           When an output is set to 1, it means the cathode of that position
 *           is off. Output of the alphabet is lowercased.
 */
module Hex_to_7Seg(hex, a, b, c, d, e, f, g);
   input       [3:0] hex;
   output reg        a, b, c, d, e, f, g;
   
   // turns off certain cathodes using a "1" to display a digit or letter
   always @(*)
   
      case(hex)
         4'h0:{a, b, c, d, e, f, g} = 7'b0000001; // display 0
         4'h1:{a, b, c, d, e, f, g} = 7'b1001111; // display 1
         4'h2:{a, b, c, d, e, f, g} = 7'b0010010; // display 2
         4'h3:{a, b, c, d, e, f, g} = 7'b0000110; // display 3
         
         4'h4:{a, b, c, d, e, f, g} = 7'b1001100; // display 4
         4'h5:{a, b, c, d, e, f, g} = 7'b0100100; // display 5
         4'h6:{a, b, c, d, e, f, g} = 7'b0100000; // display 6
         4'h7:{a, b, c, d, e, f, g} = 7'b0001111; // display 7
         
         4'h8:{a, b, c, d, e, f, g} = 7'b0000000; // display 8
         4'h9:{a, b, c, d, e, f, g} = 7'b0000100; // display 9
         4'hA:{a, b, c, d, e, f, g} = 7'b0001000; // display a
         4'hB:{a, b, c, d, e, f, g} = 7'b1100000; // display b
         
         4'hC:{a, b, c, d, e, f, g} = 7'b0110001; // display c
         4'hD:{a, b, c, d, e, f, g} = 7'b1000010; // display d
         4'hE:{a, b, c, d, e, f, g} = 7'b0110000; // display e
         4'hF:{a, b, c, d, e, f, g} = 7'b0111000; // display f
         
         // When none of the above is satisfied, defaults to this
         default:{a, b, c, d, e, f, g} = 7'b1111110; // display -
         
      endcase
      
endmodule
