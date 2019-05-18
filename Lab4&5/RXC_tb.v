`timescale 1ns / 100ps
module RXC_tb;
   reg         clk, reset;
   reg         rx;
   reg         bit8, pen;
   reg  [19:0] baud;
   wire        btu;
   wire        done;

   //Present Output
   wire        start;
   
   rx_control RXC(.clk(clk), .reset(reset), .rx(rx), .bit8(bit8), 
                  .pen(pen), .baud(baud), .btu(btu), .done(done),
                  .start(start));
                  
   //Every time unit 5 is equal to 5 ns
   always #5 clk = ~clk;

	initial begin
      {clk, reset, rx, bit8, pen} = 5'b0_0_1_0_0;
      //Fastest baud rate
      baud = 20'd109;
      //Format how time is displayed and sets it to display in nanoseconds.
      $timeformat(-9, 1, " ns", 9);
      
      @(negedge clk)
         reset = 1'b1;
      @(negedge clk)
         reset = 1'b0;
         rx = 1'b0;
      @(negedge RXC.done)
         #1000;
      $finish;
   end

endmodule
