`timescale 1ns / 1ps
//Use this to see the TX and RX in xilinx log. Use it with while checking memory in xilinx simulation
module top_level_test;

	// Inputs
	reg         clk, reset, bit8, pen, ohel, uart_txd_in;
	reg   [3:0] baudm;

	// Outputs
	wire        uart_rxd_out;
	wire [15:0] leds;

	// integers
	integer     i, j, k, c;
	
	// buffer input register
	reg  [11:0] buff, buffer;
   reg   [7:0] data;
   
	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk100mhz(clk), 
		.reset(reset), 
		.baudm(baudm), 
		.bit8(bit8), 
		.pen(pen), 
		.ohel(ohel), 
		.uart_txd_in(uart_txd_in), 
		.uart_rxd_out(uart_rxd_out), 
		.leds(leds)
	);

	// Initialize clock
   always #5 clk=~clk;

	// Each transmission add TX output to buff
	always@(posedge uut.TX.btu)begin
		#11;
		buffer[c] = uart_rxd_out;
		if (c == 10)
			c = 0;
		else
			c = c + 1;
   end
	
	always@(posedge uut.write_d[2]) begin
		#11;
		$display("leds=%b",leds);
	end
	
	always@(posedge uut.write_d[0]) begin
		#11;
		$display("PTR is %h",uut.TBT.tramelblaze.regfile[1]);
	end	
	
	always@(posedge uut.TX.txrdy) begin
		#1;
		$display("Serial data transmitted=%b", buffer);
		$display("data transmitted=%h  %c",buffer[7:1], buffer[7:1]);
   end
   
   // Check RX
	always @(posedge uut.read_d[0]) begin
      $display(" ");
      #1;
		case({bit8,pen})
			2'b00 : $display("DATA RECEIVED=%b",buff[9:0]);
			2'b01 : $display("DATA RECEIVED=%b",buff[10:0]);
			2'b10 : $display("DATA RECEIVED=%b",buff[10:0]);
			2'b11 : $display("DATA RECEIVED=%b",buff[11:0]);
		endcase
   end
   
	// Update Buffer for RX
	always @(posedge clk, posedge reset) begin
		// TX setup
		if (uut.TBT.tramelblaze.regfile[5] == 40)
			buff[8:2] = 7'h40;
		else if (i == 21 || i == 51)
		   buff[8:2] = 7'hd;
		else if (i == 29 || i == 32)
			buff[8:2] = 7'h8;
		else if (i == 35)
			buff[8:2] = 7'h2A;			
		else
			buff[8:2] = i;

		buff[1:0] = {1'b0,1'b1}; 
		
		// 3 bit correction for Transmission Buff
		case({bit8, pen, ohel})
			3'b000 : buff[11:9] <= 3'b111;
			3'b001 : buff[11:9] <= 3'b111;
			3'b010 : buff[11:9] <= {2'b11, ^data[6:0]};
			3'b011 : buff[11:9] <= {2'b11, ~(^data[6:0])};
			3'b100 : buff[11:9] <= {2'b11, data[7]};
			3'b101 : buff[11:9] <= {2'b11, data[7]};
			3'b110 : buff[11:9] <= {1'b1, ^data[7:0], data[7]};
			3'b111 : buff[11:9] <= {1'b1, ~(^data[7:0]), data[7]};
		endcase
   end
   
	initial begin
		// Initialize Inputs
		{clk, reset} = 2'b0_1;
		{bit8, pen, ohel} = 3'b0_0_0;
      baudm = 4'b0;
		uart_txd_in = 1'b1;
      c = 0;
      buff = 11'b0;
      buffer = 11'b0;
      #100;
      @(negedge clk)
      reset = ~reset;
      @(negedge clk)
         baudm = 4'b1011;
      @(posedge clk) begin
         $display("Initial");
         $display("leds=%b",leds);
      end
      // Receive
		for(i=0;i<10;i=i+1) begin
			@(negedge clk)
			$display("\nNew Data Byte Incoming for i=%d", i);
			data = i;
			if(i < 9)
				{bit8,pen,ohel} = i;
			else
				{bit8,pen,ohel} = 0;
			$display("{EIGHT,PEN,OHEL}=%b",{bit8, pen, ohel});
         $write("Incoming bit = ");
			for(k=0;k<24;k=k+1) begin
				// clk delay
				for(j=0;j<1084;j=j+1) begin
					@(negedge clk);
				end
				if (k<12) begin
					uart_txd_in = buff[k]; // recieve next bit
					$write("%b",buff[k]);
				end
				else begin
					uart_txd_in = 1'b1;
					$write("%b", uart_txd_in);
				end
			end
		end
		$finish;
	end
      
endmodule
