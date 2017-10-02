/*
	Author: Aniket Badhan
*/

`timescale 1ns/1ps

module micromachine_tb1;

	//Inputs
	reg clk;
	reg [globals::WORDLEN - 1:0] din;
	
	//Outputs
	wire din_strb;								
	wire dout_strb;								
	wire [globals::WORDLEN-1:0] dout;
	
	reg [15:0] a_data [0:15];
	int i = 0;
	
	micromachine m1(
		.clk(clk),
		.din(din),
		.din_strb(din_strb),
		.dout_strb(dout_strb),
		.dout(dout)
	);
	
	initial $readmemb("a_data.txt", a_data, 0, 15);
	
	initial begin
		clk = 0;
		din = 0;
		#5000;
		$finish;
	end
	
	always @ (posedge clk) begin
		if(i==0 || dout_strb == 1) begin
			din = a_data[i];
			i++;
			#20;
		end
	end
	
	always #5 clk = ~clk;
	
endmodule
