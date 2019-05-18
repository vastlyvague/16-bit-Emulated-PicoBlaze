`timescale 1ns / 1ps
//****************************************************************//
//  File name: rx_datapath.v                                      //
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
module rx_datapath(clk, reset, btu, start, bit8, pen, ohel, done,
                   SDI, rxrdy, perr, ferr, ovf, read, toTB);
                   
   input            clk, reset;
   input            btu, start, bit8, pen, ohel, done, read;
   
   //Serial Data Input
   input            SDI;
   
   //Output of remap to tramel blaze
   output     [7:0] toTB;
   
   //Status for recieve, parity error, framing error and overflow
   output reg       rxrdy, perr, ferr, ovf;
   reg        [9:0] shift_reg, remap;
   
   //Mux Signals that are used to create load signals to Status Regs
   wire             par, par_even, gen, SH;
   reg              stop;

/////FOR SHIFT REGISTER//////

   //Shift signal
   assign SH = btu & ~start;

   always@(posedge clk, posedge reset)
      if(reset)   shift_reg <= 10'b0;
      else if(SH) shift_reg <= {SDI, shift_reg[9:1]};
      else        shift_reg <= shift_reg;
      
/////FOR REMAP COMBO////////
   assign toTB = (bit8) ? remap[7:0] : {1'b0, remap[6:0]};
   
   always@(*)
      case({bit8, pen})
         2'b00  : remap = {2'b0, shift_reg[9:2]};
         2'b01  : remap = {1'b0, shift_reg[9:1]};
         2'b10  : remap = {1'b0, shift_reg[9:1]};
         default: remap = shift_reg;
      endcase

   //Parity Gen Select
   assign gen = (bit8) ? remap[7] : 1'b0;
   
   //Even Parity Mux
   assign par_even = (~ohel) ?  (remap[6:0] ^ gen) :
                               ~(remap[6:0] ^ gen) ;

   //Parity Bit Select
   assign par = (bit8) ? remap[8] : remap[7];

   //Stop Bit Select
   always@(*)
      case({bit8, pen})
         2'b00  : stop = ~remap[7];
         2'b11  : stop = ~remap[9];
         default: stop = ~remap[8];
      endcase
      
/////STATUS REGISTERS///////   
   //RXRDY REG
   always@(posedge clk, posedge reset)
      if(reset)             rxrdy <= 1'b0;
      else if(read)         rxrdy <= 1'b0;
      else if(done)         rxrdy <= 1'b1;
      else                  rxrdy <= rxrdy;

   //PERR REG
   always@(posedge clk, posedge reset)
      if(reset)             perr <= 1'b0;
      else if(read)         perr <= 1'b0;
      else if(done & (par ^ par_even) & pen)
                            perr <= 1'b1;
      else                  perr <= perr;

   //FERRR REG
   always@(posedge clk, posedge reset)
      if(reset)             ferr <= 1'b0;
      else if(read)         ferr <= 1'b0;
      else if(done & stop)  ferr <= 1'b1;
      else                  ferr <= ferr;

   //OVF REG
   always@(posedge clk, posedge reset)
      if(reset)             ovf <= 1'b0;
      else if(read)         ovf <= 1'b0;
      else if(done & rxrdy)
                            ovf <= 1'b1;
      else                  ovf <= ovf;

endmodule
