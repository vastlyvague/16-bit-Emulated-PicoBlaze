`timescale 1ns / 1ps
//****************************************************************// 
//  File name: debounce.v                                         // 
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
module debounce(clk, reset, tick, INC, pout);

input             clk, reset, tick, INC;
output reg        pout;
reg        [2:0]  nstate, pstate;
reg               nout;

// Next State Combinational Logic    
always @ (*) 
	casex ({pstate, tick, INC})
      // State 0_0 // require INC to reach stabilization on press
      5'b000_x_1 : {nstate, nout} = {3'b001, 1'b0};
      // State 0_1
      5'b001_0_1 : {nstate, nout} = {3'b001, 1'b0};
      5'b001_1_1 : {nstate, nout} = {3'b010, 1'b0};
      // State 0_2
      5'b010_0_1 : {nstate, nout} = {3'b010, 1'b0};
      5'b010_1_1 : {nstate, nout} = {3'b011, 1'b0};
      // State 0_3
      5'b011_0_1 : {nstate, nout} = {3'b011, 1'b0};
      5'b011_1_1 : {nstate, nout} = {3'b100, 1'b0};
      // State 1_0 // inverts required INC to reach stabilization on release
      5'b100_x_1 : {nstate, nout} = {3'b100, 1'b1};
      5'b100_x_0 : {nstate, nout} = {3'b101, 1'b1};
      // State 1_1
      5'b100_x_1 : {nstate, nout} = {3'b100, 1'b1};
      5'b101_0_0 : {nstate, nout} = {3'b110, 1'b1};
      5'b101_1_0 : {nstate, nout} = {3'b101, 1'b1};
      // State 1_2
      5'b100_x_1 : {nstate, nout} = {3'b100, 1'b1};
      5'b110_0_0 : {nstate, nout} = {3'b111, 1'b1};
      5'b110_1_0 : {nstate, nout} = {3'b110, 1'b1};
      // State 1_3
      5'b100_x_1 : {nstate, nout} = {3'b100, 1'b1};
      5'b111_0_0 : {nstate, nout} = {3'b100, 1'b1};
      5'b111_1_0 : {nstate, nout} = {3'b111, 1'b1};
 
      default : {nstate, nout} = {3'b000, 1'b0};
   endcase

// State Register Sequential Logic
always @ (posedge clk or posedge reset)
	if (reset == 1) begin
		pstate <= 3'b000;
      pout <= 3'b000;
      end
	else begin
		pstate <= nstate;
      pout <= nout;
      end
      
endmodule
