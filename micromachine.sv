/*
	Author: Aniket Badhan
*/

`timescale 1ns/1ps

`include "GlobalConstants.svh"

module micromachine(
	input clk,
	input [globals::WORDLEN - 1:0] din,					
	output reg din_strb,								
	output reg dout_strb,								
	output reg [globals::WORDLEN-1:0] dout
);
	
	reg carry_out = 0;
	reg zero = 0;
	wire ctl_ot;
	wire [3:0] ctl_sbus;
	wire [3:0] ctl_alu;
	wire [2:0] ctl_shft;
	wire ctl_acc;
	wire [3:0] ctl_dest;
	wire [globals::WORDLEN-1:0] rf_out;
	reg  [globals::WORDLEN-1:0] rf_in = 0;
	reg [globals::WORDLEN-1:0] sbus = 0;
	reg [globals::WORDLEN-1:0] alu_in = 0;
	wire [globals::WORDLEN-1:0] alu_out;
	reg [globals::WORDLEN-1:0] shft_in = 0;
	wire [globals::WORDLEN-1:0] shft_out;
	wire [11:0] ctl_address;
	
	control c1(
		.clk(clk),
		.input1(carry_out),
		.input2(zero),
		.out1(ctl_ot),
		.out2(ctl_sbus),
		.out3(ctl_alu),
		.out4(ctl_shft),
		.out5(ctl_dest),
		.out6(ctl_address)
	);
	
	regfile r1(
		.clk(clk),
		.input1(ctl_dest),
		.input2(ctl_sbus),
		.input3(ctl_address),
		.input4(shft_out),
		.out(rf_out)
	);
	
	alu a1(
		.clk(clk),
		.input1(ctl_dest),
		.input2(ctl_alu),
		.input3(sbus),
		.input4(shft_out),
		.out1(alu_out)
	);
	
	shifter s1(
		.clk(clk),
		.input1(ctl_shft),
		.input2(alu_out),
		.out1(zero),
		.out2(carry_out),
		.out3(shft_out)
	);
	
	always_comb begin
		if(ctl_sbus == globals::SBUS_IN) begin
			sbus = din;
		end
		else begin
			sbus = rf_out;
		end
		
	end
	
	always @ (posedge clk) begin
		if(ctl_sbus == globals::SBUS_IN) begin
			din_strb <= 1;
		end
		else begin
			din_strb <= 0;
		end
		
		//dout <= sbus;
		
		if(ctl_ot == globals::O_WR) begin
			dout_strb <= 1;
			dout <= sbus;
		end
		else begin
			dout_strb <= 0;
			dout <= 0;
		end
		
	end
	
	
endmodule
