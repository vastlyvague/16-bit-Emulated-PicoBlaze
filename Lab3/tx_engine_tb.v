`timescale 1ns / 100ps
//****************************************************************//
//  File name: tx_engine_tb.v                                     //
//                                                                //
//  Created by       Thomas Nguyen on 2/28/19.                    //
//  Copyright c 2019 Thomas Nguyen. All rights reserved.          //
//                                                                //
//                                                                //
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that    //
//  plagiarism in student project work is subject to dismissal.   //
//  from the class                                                //
//****************************************************************//
module tx_engine_tb;

	// Inputs
	reg       clk, reset, ld, bit8, pen, ohel;
	reg [3:0] baud_mode;
	reg [7:0] out_port;

	// Outputs
	wire      tx, txrdy;
   
   integer    i, j;

	// Instantiate the Unit Under Test (UUT)
	tx_engine uut (
		.clk(clk), 
		.reset(reset), 
		.ld(ld), 
		.bit8(bit8), 
		.pen(pen), 
		.ohel(ohel), 
		.baud_mode(baud_mode), 
		.out_port(out_port), 
		.tx(tx), 
		.txrdy(txrdy)
	);

   //Every time unit 5 is equal to 5 ns
   always #5 clk = ~clk;
   
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		{bit8, pen, ohel, ld} = 4'b0_0_0_0;
      
		baud_mode = 4'b1011; //Fastest Baud Rate Mode
		out_port = 8'hAA;    //Repeating 1 and 0s

      //Format how time is displayed and sets it to display in nanoseconds.
      $timeformat(-9, 1, " ns", 9);
      
      $display("-----------------------------------------------------------------");
      $display("CECS 460 Lab 2: Transmit Engine Test Bench ");
      $display("-----------------------------------------------------------------");
      $display(" ");
      
      @(negedge clk) //Change inputs on negedge to prevent metastability
         reset = 1;
      @(negedge clk)
         reset = 0;

      //Cycles through all possible bits and increments out_port
      for(i=0; i<8; i=i+1) begin
         @(negedge clk)
            {bit8, pen, ohel} = i;
            out_port = out_port + i;
            ld = 1'b1;
         @(negedge clk)
            ld = 1'b0;

         //Call reusable task
         display_out;
      end

      $finish;
	end
   
   task display_out;
      begin
         @(posedge clk)
            #1 $display("{bit8, pen, ohel} = %b --- Out_Port = %b",
                         {bit8, pen, ohel},         out_port);

            $write("TRANSMIT (LSB to MSB) and SHIFT Comparison:\n");
            $display("Shift  = %b", uut.shift);
            $write("TX     = ");
         //Displays TX from LSB to MSB
         for(j=0; j<11; j=j+1) begin
            @(posedge uut.btu)
               #6 $write("%b",tx);
         end
         $write("\n");
         case({bit8, pen, ohel})
            3'b010 : #1 $display("EP bit = %b",(^out_port[6:0]));
            3'b011 : #1 $display("OP bit = %b",(~^out_port));
            3'b110 : #1 $display("EP bit = %b",(^out_port));
            3'b111 : #1 $display("OP bit = %b",(~^out_port));
            default: #1 $display("NP bit");
         endcase
         $write("\n");
      end
   endtask
      
endmodule

