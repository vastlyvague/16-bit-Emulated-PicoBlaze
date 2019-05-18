`timescale 1ns / 1ps
//****************************************************************//
//  File name: tx_engine.v                                        //
//                                                                //
//  Created by       Thomas Nguyen on 2/18/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module tx_engine(  clk, reset, ld, bit8, pen, ohel, baud_rate,
                   out_port, tx, txrdy);

   input              clk, reset, ld, bit8, pen, ohel;
   input        [7:0] out_port;
   input       [19:0] baud_rate;    //Baud count value

   output             tx;           //Transmit

   //flip flops
   output reg         txrdy;        //Transmit Ready
   reg                doit, loaddi;

   //registers
   reg          [7:0] ldata;        //Ldata
   reg         [10:0] shift;        //Shift Register

   //counters
   reg          [3:0] bc, bc_i;     //Bit Count Value
   reg         [19:0] btc, btc_i;   //Bit Time Count Value

   wire               done, btu;
   reg          [1:0] parity;       //2 MSB for Shift Register

   ////////////COUNTERS//////////////////
   //bit counter
   assign done = (bc_i == 4'b1011);

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

   //bit time counter
   assign btu = (btc_i == baud_rate);

   always@(*)
      if(btu)         btc = 20'b0; 
      else if({doit, btu} == 2'b10)
                      btc = btc_i + 20'b1;
      else            btc = 20'b0;

   always@(posedge clk, posedge reset)
      if(reset)       btc_i <= 20'b0;
      else            btc_i <= btc;

   // ------------ FLIP FLOPS ------------ //
   //loaddi flop
   always@(posedge clk, posedge reset)
      if(reset)       loaddi <= 1'b0;
      else            loaddi <= ld;

   //RS flop called DOIT
   always@(posedge clk, posedge reset)
      if(reset)       doit <= 1'b0;
      else if(done)   doit <= 1'b0;
      else if(loaddi) doit <= 1'b1;
      else            doit <= doit;

   //TX bit
   assign tx = shift[0];

   //TXRDY RS flop (LOW ACTIVE)
   always@(posedge clk, posedge reset)
      if(reset)       txrdy <= 1'b1;
      else if(ld)     txrdy <= 1'b0;
      else if(done)   txrdy <= 1'b1;
      else            txrdy <= txrdy;

   // ------------ REGISTERS ------------ //
   //ldata register
   always@(posedge clk, posedge reset)
      if(reset)       ldata <= 8'b0;
      else if(ld)     ldata <= out_port;
      else            ldata <= ldata;

   //shift register
   always@(posedge clk, posedge reset)
      if(reset)       shift <= 11'h7ff;
      else if(loaddi) shift <= {parity, ldata[6:0], 1'b0, 1'b1};
      else if(btu)    shift <= {1'b1, shift[10:1]};
      else            shift <= shift;

   //2-bit data for parity
   always@(*)
      case({bit8, pen, ohel})
         3'h2   : parity = {   1'b1,   (^ldata[6:0])};
         3'h3   : parity = {   1'b1,  ~(^ldata[6:0])};
         3'h4   : parity = {   1'b1,        ldata[7]};
         3'h5   : parity = {   1'b1,        ldata[7]};
         3'h6   : parity = { (^ldata),      ldata[7]};
         3'h7   : parity = {~(^ldata),      ldata[7]};
         default: parity =     2'b11;
      endcase
                              
endmodule
