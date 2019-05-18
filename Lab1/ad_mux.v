//****************************************************************// 
//  File name: ad_mux.v                                           // 
//                                                                // 
//  Created by       Thomas Nguyen on 3/10/18    .                // 
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
// This module takes in the input selector from the 
//	pixel controller and uses to deteremine the input for the 
//	HEX to 7 display segement.
////////////////////////////////////////////////////////////////////
module ad_mux(Y, seg_sel, D0, D1, D2, D3, D4, D5, D6, D7);
  output    [3:0]  Y;
  input     [2:0]  seg_sel;
  input     [3:0]  D0, D1, D2, D3, D4, D5, D6, D7;
  reg       [3:0]  Y;
  
  // selects the value of Y based on seg_sel
  always @ (D0 or D1 or D2 or D3 or D4 or D5 or D6 or D7 or seg_sel)
		case(seg_sel)
			3'b000: Y = D0;
			3'b001: Y = D1;	
			3'b010: Y = D2;
			3'b011: Y = D3;	
			3'b100: Y = D4;
			3'b101: Y = D5;	
			3'b110: Y = D6;
			3'b111: Y = D7;
		  default: Y =  4'h0;
      endcase	
  
endmodule
