`timescale 1ns / 1ps
//****************************************************************//
//  File name: baud_dec.v                                         //
//                                                                //
//  Created by       Thomas Nguyen on 3/17/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module baud_dec(baud_mode, baud_rate);
input       [3:0] baud_mode;
output reg [19:0] baud_rate;

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

endmodule
