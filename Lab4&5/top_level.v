`timescale 1ns / 1ps
//****************************************************************//
//  File name: top_level.v                                        //
//                                                                //
//  Created by       Thomas Nguyen on 5/01/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module top_level(SYS_CLK, SYS_RST, i_RX, i_SW, o_TX, o_LED);

   input         SYS_CLK, SYS_RST, i_RX;
   input   [7:0] i_SW;
   
   output        o_TX;
   output [15:0] o_LED;
   
   wire          w_CLK, w_RST, w_TX, w_RX;
   wire    [7:0] w_SW;
   wire   [15:0] w_LED;
   
   TSI       tsi(.SYS_CLK(SYS_CLK), .SYS_RST(SYS_RST), .i_RX(i_RX),
                 .i_SW(i_SW),       .o_TX(o_TX),       .o_LED(o_LED),
                 .i_TX(w_TX),       .i_LED(w_LED),     .o_CLK(w_CLK),
                 .o_RST(w_RST),     .o_RX(w_RX),       .o_SW(w_SW));
           
   SOPC_CORE cor(.clk100mhz(w_CLK), .reset(w_RST), .baudm(w_SW[7:4]), 
                 .bit8(w_SW[3]),    .pen(w_SW[2]), .ohel(w_SW[1]),
                 .uart_txd_in(w_RX), 
                 .uart_rxd_out(w_TX), .leds(w_LED));

endmodule
