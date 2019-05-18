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
module tx_engine(  clk, reset, ld, bit8, pen, ohel, baud_mode,
                   out_port, tx, txrdy);

input              clk, reset, ld, bit8, pen, ohel;
input        [3:0] baud_mode;
input        [7:0] out_port;

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
reg         [19:0] baud_rate;    //Baud count value

////////////COUNTERS//////////////////
//bit counter
assign done = (bc_i == 4'b1011);

always@(*)
   if(done)        bc = 4'b0;
   else if({doit, btu} == 2'b11)
                   bc = bc_i + 4'b1;
   else            bc = bc_i;

always@(posedge clk, posedge reset)
   if(reset)       bc_i <= 4'b0;
   else            bc_i <= bc;

//bit time counter
assign btu = (btc_i == baud_rate);

always@(*)
   if(btu)         btc = 20'b0; 
   else if({doit, btu} == 2'b10)
                   btc = btc_i + 20'b1;
   else            btc = btc_i;

always@(posedge clk, posedge reset)
   if(reset)       btc_i <= 20'b0;
   else            btc_i <= btc;

// ------------ Get Baud Rate --------- //
always@(*)
   case(baud_mode)
      // ------------------ Count No. ------ Rate
      4'b0000 : baud_rate = 20'd333_333; //   300
      4'b0001 : baud_rate = 20'd083_333; //  1200
      4'b0010 : baud_rate = 20'd041_667; //  2400
      4'b0011 : baud_rate = 20'd020_833; //  4800
      4'b0100 : baud_rate = 20'd010_417; //  9600
      4'b0101 : baud_rate = 20'd005_208; // 19200
      4'b0110 : baud_rate = 20'd002_604; // 38400
      4'b0111 : baud_rate = 20'd001_736; // 57600
      4'b1000 : baud_rate = 20'd000_868; //115200
      4'b1001 : baud_rate = 20'd000_434; //230400
      4'b1010 : baud_rate = 20'd000_217; //460800
      default : baud_rate = 20'd000_109; //921600
   endcase

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
