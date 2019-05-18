`timescale 1ns / 1ps
//****************************************************************//
//  File name: top_level.v                                        //
//                                                                //
//  Created by       Thomas Nguyen on 1/29/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module tramelblaze_top_tf;

reg         CLK, RESET, INTERRUPT;
reg  [15:0] IN_PORT;
wire [15:0] OUT_PORT, PORT_ID;
wire        READ_STROBE, WRITE_STROBE, INTERRUPT_ACK;
integer     i;

tramelblaze_top tbt (
                     .CLK(CLK),
                     .RESET(RESET),
                     .IN_PORT(IN_PORT),
                     .INTERRUPT(INTERRUPT),
                     .OUT_PORT(OUT_PORT),
                     .PORT_ID(PORT_ID),
                     .READ_STROBE(READ_STROBE),
                     .WRITE_STROBE(WRITE_STROBE),
                     .INTERRUPT_ACK(INTERRUPT_ACK)
                     );

always #5 CLK = ~CLK;

initial
   begin
   CLK = 0;
   IN_PORT = 0;
   INTERRUPT = 0;
   RESET = 1;
   #100
   RESET = 0;
   for(i=0; i<3; i=i+1)
      begin
      #1000
      @(posedge CLK)
      INTERRUPT = 1;
      @(posedge INTERRUPT_ACK)
      INTERRUPT = 0;
      end
   $finish;
   end
   
endmodule
