`timescale 1ns / 1ps
//****************************************************************//
//  File name: SOPC_CORE.v                                        //
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
module SOPC_CORE(clk100mhz, reset, baudm, bit8, pen, ohel, 
                 uart_txd_in, uart_rxd_out, leds);

   input         clk100mhz, reset;
   //Baud rate mode
   input   [3:0] baudm;
   //Status Flags
   input         bit8, pen, ohel;
   //Receive signal
   input         uart_txd_in;
   //Transmit signal
   output        uart_rxd_out;
   //16 LEDs
   output [15:0] leds;
   reg    [15:0] leds;
   //Tramelblaze
   wire   [15:0] inport, outport, portid;
   wire          rst_sync;
   wire          ped_d;
   
   wire    [7:0] rx_out;
   wire    [7:0] UARTCONFIG;
   wire   [15:0] write_d, read_d, SRAM_out;
   wire   [19:0] br;

   // -------------------- INSTANTIATE MODULES -------------------------------
   AISO_register       AISO(.clk(clk100mhz), .reset(reset), .reset_sync(rst_sync));
   
   LD_reg                LR(.clk(clk100mhz), .reset(rst_sync), .ld(write_d[6]), 
                            .d(outport[7:0]), .q(UARTCONFIG));

   baud_dec            BAUD(.baud_mode(UARTCONFIG[7:4]), .baud_rate(br));

   tx_engine             TX(.clk(clk100mhz), .reset(rst_sync), .ld(write_d[0]),
                            .bit8(UARTCONFIG[3]), .pen(UARTCONFIG[2]), 
                            .ohel(UARTCONFIG[1]),
                            .baud_rate(br), .out_port(outport[7:0]),
                            .tx(uart_rxd_out), .txrdy(txrdy));

   rx_engine             RX(.clk(clk100mhz), .reset(rst_sync), .rx(uart_txd_in),
                            .bit8(UARTCONFIG[3]), .pen(UARTCONFIG[2]), 
                            .ohel(UARTCONFIG[1]), .br(br), 
                            .rxrdy(rxrdy), .perr(perr), .ferr(ferr), .ovf(ovf),
                            .rx_out(rx_out), .read(read_d[0]));

   posedge_detect     PEDTX(.clk(clk100mhz), .reset(rst_sync), .INC_db_in(txrdy),
                            .POS_detect(ped_tx));
                            
   posedge_detect     PEDRX(.clk(clk100mhz), .reset(rst_sync), .INC_db_in(rxrdy),
                            .POS_detect(ped_rx));

   SR_flop              SRF(.clk(clk100mhz),                   .rst_sync(rst_sync),
                            .reset(interruptack),              .set(ped_d), 
                            .interrupt(interrupt));
                            
   tramelblaze_top_sim      TBT(.CLK(clk100mhz),                   .RESET(rst_sync), 
                            .IN_PORT(inport),                  .INTERRUPT(interrupt),
                            .OUT_PORT(outport),                .PORT_ID(portid),
                            .WRITE_STROBE(writestrobe),        
                            .READ_STROBE(readstrobe),
                            .INTERRUPT_ACK(interruptack));

   SRAM 		           SRAM(.clka(clk100mhz),
                            .wea(portid[15] && writestrobe),   .addra(portid[14:0]),
                            .dina(outport),                    .douta(SRAM_out));

   //TXRDY OR RXRDY combo
   assign ped_d = ((ped_tx | ped_rx) == 1'b1);

   //mux for inport
   assign inport = (read_d[5]) ? {8'b0, baudm, bit8, pen, ohel, 1'b0}:
                   (read_d[1]) ? {11'b0, ovf, ferr, perr, txrdy, rxrdy}:
                   (read_d[0]) ? {8'b0, rx_out}:
                                 SRAM_out;

   //Address decoder for write and read
   addr_dec             DEC(.portid(portid), .ws(writestrobe),  .wr(write_d),
                            .rs(readstrobe), .rd(read_d));

   always@(posedge clk100mhz)
      if(rst_sync)
         leds <= 16'b0;
      else if(write_d[2])
         leds <= outport;
      else
         leds <= leds;

endmodule
