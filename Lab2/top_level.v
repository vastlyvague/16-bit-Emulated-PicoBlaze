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
module top_level(clk100mhz, reset, baudm, bit8, pen, ohel, 
                 uart_rxd_out, leds);

input         clk100mhz, reset;
// baud rate mode
input   [3:0] baudm;

input         bit8, pen, ohel;
// Transmit signal
output        uart_rxd_out;
// 16 LEDs
output [15:0] leds;
//Tramelblaze
wire   [15:0] outport;
wire   [15:0] portid;
wire          rst_sync;
wire          ped_d;
wire    [7:0] write_dec;
wire    [7:0] read_dec;

// 10ms tick manipulator
wire          tick;
reg    [19:0] count, d;

// -------------------- INSTANTIATE MODULES -------------------------------
AISO_register      uut1 (.clk(clk100mhz), .reset(reset),    .reset_sync(rst_sync));

tx_engine          uut2 (.clk(clk100mhz), .reset(rst_sync), .ld(write_dec[0]),
                         .bit8(bit8),     .pen(pen),        .ohel(ohel),
                         .baud_mode(baudm),                 .out_port(outport[7:0]),
                         .tx(uart_rxd_out),                 .txrdy(txrdy));

posedge_detect     uut3 (.clk(clk100mhz), .reset(rst_sync), .INC_db_in(txrdy),
                         .POS_detect(ped_d));

SR_flop            uut4 (.clk(clk100mhz),                   .rst_sync(rst_sync),
                         .reset(interruptack),              .set(ped_d), 
                         .interrupt(interrupt));
                         
tramelblaze_top     tbt (.CLK(clk100mhz),                   .RESET(rst_sync), 
                         .IN_PORT(16'b0),                   .INTERRUPT(interrupt),
                         .OUT_PORT(outport),                .PORT_ID(portid),
                         .WRITE_STROBE(writestrobe),        .READ_STROBE(readstrobe),
                         .INTERRUPT_ACK(interruptack));

//Address decoder for write and read
addr_dec          write (.s({portid[2], portid[1], portid[0]}), .EN(~portid[15]),
                         .strobe(writestrobe),                  .wr(write_dec));
addr_dec           read (.s({portid[2], portid[1], portid[0]}), .EN(~portid[15]),
                         .strobe(readstrobe),                   .wr(read_dec));

// delay pulse for LEDs
assign tick = (count==20'd4096);

always @(*)
   if(tick)      d = 20'b0;
   else          d = count + 20'b1;
  
always @(posedge clk100mhz, posedge reset)
   if(reset)     count <= 20'b0;
   else          count <= d;

assign leds = (tick && write_dec[1]) ? outport : leds;

endmodule