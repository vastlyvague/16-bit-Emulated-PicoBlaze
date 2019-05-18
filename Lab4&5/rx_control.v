`timescale 1ns / 1ps
//****************************************************************//
//  File name: rx_control.v                                       //
//                                                                //
//  Created by       Thomas Nguyen on 3/18/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module rx_control(clk, reset, rx, baud, start, bit8, pen, done, btu);

   input         clk, reset;
   input         rx;
   input         bit8, pen;
   input  [19:0] baud;
   output        btu;
   output        done;

   //Present Output
   output        start;
   reg           start;
   reg           doit;
   reg     [1:0] state;
   
   //Next Outputs
   reg           nstart, ndoit;
   reg     [1:0] nstate;
   
   //Counters
   reg     [3:0] bc, bc_i;     //Bit Count Value
   reg    [19:0] btc, btc_i;   //Bit Time Count Value

   reg     [3:0] num;
   wire   [19:0] start_mux;

   ////////////COUNTERS//////////////////
   //Bit Time Counter
   assign btu = (btc_i == start_mux);

   always@(*)
      if(btu)         btc = 20'b0; 
      else if({doit, btu} == 2'b10)
                      btc = btc_i + 20'b1;
      else            btc = 20'b0;

   always@(posedge clk, posedge reset)
      if(reset)       btc_i <= 20'b0;
      else            btc_i <= btc;
      
   //Bit Counter
   assign done = (bc_i == num);

   always@(*)
      if(done)        bc = 4'b0;
      else if({doit, btu} == 2'b11)
                      bc = bc_i + 4'b1;
      else if({doit, btu} == 2'b10)
                      bc = bc_i;
      else            bc = 4'b0;

   always@(posedge clk, posedge reset)
      if(reset)       bc_i <= 4'b0;
      else            bc_i <= bc;
   
   //Combination logic for Bit Counter to increment to
   always@(*)
      case({bit8, pen})
         2'b00  : num = 4'h9;
         2'b11  : num = 4'hB;
         default: num = 4'hA;
      endcase

   //Start Select Mux for K and K/2   
   assign start_mux = (start) ? (baud >> 1) : baud;

   //FINITE STATE MACHINE (FSM)
   //Modified Moore to ensure that the start bit remains
   //active for half a bit time.
   always@(posedge clk, posedge reset)
      if(reset) {state, start, doit} <= 4'b00_0_0;
      else      {state, start, doit} <= {nstate, nstart, ndoit};
      
   always@(*)
      case(state)
         2'b00  : {nstate, nstart, ndoit} = (rx)   ? 4'b00_0_0 : 
                                                     4'b01_1_1 ;
         2'b01  : {nstate, nstart, ndoit} = (rx)   ? 4'b00_0_0 :
                                            (!btu) ? 4'b01_1_1 :
                                                     4'b10_0_1 ;
         2'b10  : {nstate, nstart, ndoit} = (done) ? 4'b00_0_0 :
                                                     4'b10_0_1 ;
         default: {nstate, nstart, ndoit} =          4'b00_0_0 ;
      endcase
      
endmodule
