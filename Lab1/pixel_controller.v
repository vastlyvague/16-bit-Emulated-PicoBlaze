`timescale 1ns / 1ps
//****************************************************************// 
//  File name: pixel_controller.v                                 // 
//                                                                // 
//  Created by       Thomas Nguyen on 01/29/2019.                 // 
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
// This module is the pixel controller. It implements the moore type
// Finite Statemachine Verliog Broiler #2. This module is always 
// switching to another state and never stays in one state. The
// output of this module is a selector for a mux, and the led 
// for the anodes.
////////////////////////////////////////////////////////////////////
module pixel_controller(clk, reset, tick, an, seg_sel);

input 		      clk, reset, tick;
output reg [7:0]  an;
output reg [2:0]  seg_sel;

reg        [7:0]  n_an;
reg 	     [2:0]  nstate, pstate;

// Next State Combinational Logic    
always @ (pstate or tick) 
	case ({pstate, tick})
      4'b000_0: {nstate, seg_sel, n_an} = {3'h0, 3'h0, 8'hfe};
      4'b000_1: {nstate, seg_sel, n_an} = {3'h1, 3'h1, 8'hfd};
      
      4'b001_0: {nstate, seg_sel, n_an} = {3'h1, 3'h1, 8'hfd};
      4'b001_1: {nstate, seg_sel, n_an} = {3'h2, 3'h2, 8'hfb};
      
      4'b010_0: {nstate, seg_sel, n_an} = {3'h2, 3'h2, 8'hfb};
      4'b010_1: {nstate, seg_sel, n_an} = {3'h3, 3'h3, 8'hf7};
      
      4'b011_0: {nstate, seg_sel, n_an} = {3'h3, 3'h3, 8'hf7};
      4'b011_1: {nstate, seg_sel, n_an} = {3'h4, 3'h4, 8'hef};
      
      4'b100_0: {nstate, seg_sel, n_an} = {3'h4, 3'h4, 8'hef};
      4'b100_1: {nstate, seg_sel, n_an} = {3'h5, 3'h5, 8'hdf};
      
      4'b101_0: {nstate, seg_sel, n_an} = {3'h5, 3'h5, 8'hdf};
      4'b101_1: {nstate, seg_sel, n_an} = {3'h6, 3'h6, 8'hbf};
      
      4'b110_0: {nstate, seg_sel, n_an} = {3'h6, 3'h6, 8'hbf};
      4'b110_1: {nstate, seg_sel, n_an} = {3'h7, 3'h7, 8'h7f};
      
      4'b111_0: {nstate, seg_sel, n_an} = {3'h7, 3'h7, 8'h7f};
      4'b111_1: {nstate, seg_sel, n_an} = {3'h0, 3'h0, 8'hfe};
 
      default : {nstate, seg_sel, n_an} = {3'h0, 3'h0, 8'hfe};
   endcase

// State Register Sequential Logic
always @ (posedge clk or posedge reset)
	if (reset == 1) begin
		pstate   <= 3'b0;
      an       <= 8'b0;
      end
	else begin
      // Output logic
		pstate   <= nstate;
      an       <= n_an;
      end

endmodule
