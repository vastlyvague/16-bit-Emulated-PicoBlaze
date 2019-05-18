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
module TSI(SYS_CLK, SYS_RST, i_RX, i_SW, i_TX, i_LED,
           o_CLK, o_RST, o_RX, o_SW, o_TX, o_LED);

   input          SYS_CLK, SYS_RST, i_RX;
   input    [7:0] i_SW;
   
   input          i_TX;
   input   [15:0] i_LED;
   
   output         o_CLK, o_RST, o_RX;
   output   [7:0] o_SW;
   
   output         o_TX;
   output  [15:0] o_LED;   
   
   //Input Buffer
   IBUFG #(.IOSTANDARD("DEFAULT"))
   SYSTEM_CLK(.O(o_CLK), .I(SYS_CLK));
   
   IBUF #(.IOSTANDARD("DEFAULT"))
   SYSTEM_RESET(.O(o_RST), .I(SYS_RST));
   
   IBUF #(.IOSTANDARD("DEFAULT"))
   RX(.O(o_RX), .I(i_RX));
   
   IBUF #(.IOSTANDARD("DEFAULT"))
   SWITCHES[7:1](.O(o_SW[7:1]), .I(i_SW[7:1]));   

   //Output Buffer
   OBUF #(.IOSTANDARD("DEFAULT"))
   TX(.O(o_TX), .I(i_TX));
   
   OBUF #(.IOSTANDARD("DEFAULT"))
   LED[15:0](.O(o_LED), .I(i_LED));
   
endmodule
