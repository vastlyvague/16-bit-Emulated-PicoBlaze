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
module top_level(clk100mhz, reset, btn, uphdnl, an, ca);

input         clk100mhz, reset, btn, uphdnl;
// 7 segment display
output [7:0]  an;
// cathodes to hex display abcdefg
output [6:0]  ca;

//Tramelblaze
wire   [15:0] inport;
wire   [15:0] outport;
wire   [15:0] portid;

wire          rst_sync;
wire          db_to_ped;
wire          ped_d;
wire   [15:0] c_seg;

// 10ms tick manipulator
wire          tick_10ms;
reg    [19:0] count, d;
	
// 10ms clock tick
assign tick_10ms = (count==20'd999_999);
  
always @(*)
  if(tick_10ms) d = 20'b0; else
            d = count + 20'b1;
always @(posedge clk100mhz or posedge reset)
  if(reset) count<=20'b0; else
            count<=d;

// comparator - connects tramelblaze_top to reg16_ld
assign w_comparator = (portid == 16'h1234);
assign writeled = (writestrobe && w_comparator);
///////////////////////////////////////
AISO_register      uut1 (.clk(clk100mhz), .reset(reset), .reset_sync(rst_sync));
debounce           uut2 (.clk(clk100mhz), .reset(rst_sync), .tick(tick_10ms),
                         .INC(btn), .pout(db_to_ped));
posedge_detect     uut3 (.clk(clk100mhz), .reset(rst_sync), .INC_db_in(db_to_ped),
                         .POS_detect(ped_d));
SR_flop            uut4 (.clk(clk100mhz), .rst_sync(rst_sync), .reset(interruptack), 
                         .set(ped_d), .interrupt(interrupt));
tramelblaze_top     tbt (.CLK(clk100mhz), .RESET(rst_sync), .IN_PORT({15'h0, uphdnl}),
                         .INTERRUPT(interrupt), .OUT_PORT(outport), .PORT_ID(portid),
                         .READ_STROBE(), .WRITE_STROBE(writestrobe),
                         .INTERRUPT_ACK(interruptack));                         
reg16_ld           uut5 (.clk(clk100mhz), .reset(rst_sync), .load(writeled), .d(outport),
                         .q(c_seg));
display_controller uut6 (.clk(clk100mhz), .reset(rst_sync), .seg0(c_seg[3:0]), 
                         .seg1(c_seg[7:4]), .seg2(c_seg[11:8]), .seg3(c_seg[15:12]),
                         .seg4(c_seg[3:0]), .seg5(c_seg[7:4]), .seg6(c_seg[11:8]), 
                         .seg7(c_seg[15:12]), .an(an), .ca(ca[0]), .cb(ca[1]), .cc(ca[2]),
                         .cd(ca[3]), .ce(ca[4]), .cf(ca[5]), .cg(ca[6]));

endmodule
