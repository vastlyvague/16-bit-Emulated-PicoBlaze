`timescale 1ns / 1ps
//****************************************************************//
//  File name: rx_engine.v                                        //
//                                                                //
//  Created by       Thomas Nguyen on 3/26/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module rx_engine(clk, reset, rx, bit8, pen, ohel, br, rxrdy, perr,
                 ferr, ovf, rx_out, read);
   input         clk, reset;
   input         rx, bit8, pen, ohel, read;
   input  [19:0] br;
   output        rxrdy, perr, ferr, ovf;
   output  [7:0] rx_out;

   wire          btu, done, start;

   rx_control           RXC(.clk(clk), .reset(reset), .rx(rx),
                            .baud(br), .start(start),
                            .bit8(bit8), .pen(pen), .done(done), .btu(btu));

   rx_datapath          RXD(.clk(clk), .reset(reset), .btu(btu),
                            .start(start), .bit8(bit8), .pen(pen),
                            .ohel(ohel), .done(done), .SDI(rx), 
                            .rxrdy(rxrdy), .perr(perr), .ferr(ferr),
                            .ovf(ovf), .toTB(rx_out), .read(read));
endmodule
