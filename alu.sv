/*
	Author: Aniket Badhan
*/

`timescale 1ns/1ps

module alu(
	input clk,
	input [3:0] input1,									//ctl_dest
	input [3:0] input2,									//ctl_alu
	input [globals::WORDLEN-1:0] input3,			//sbus	
	input [globals::WORDLEN-1:0] input4,			//shift
	output reg [globals::WORDLEN-1:0] out1			//q
);

	reg [globals::WORDLEN-1:0] acc = 0;
	
	always @ (posedge clk) begin
		if(input1 == globals::DST_ACC) begin
			acc <= input4;
		end
		else begin
			acc <= acc;
		end
		
	end

	always_comb begin
		
		case(input2)
			globals::ALU_ACC	:	begin
								out1 = acc;
							end
			globals::ALU_PASS	:	begin
								out1 = input3;
							end
			globals::ALU_ADD	:	begin
								out1 = acc + input3;
							end
			globals::ALU_SUBA	:	begin
								out1 = acc - input3;
							end
			globals::ALU_SUBS	:	begin
								out1 = input3 - acc;
							end
			globals::ALU_AND	:	begin
								out1 = acc & input3;
							end
			globals::ALU_OR		:	begin
								out1 = acc | input3;
							end
			globals::ALU_NOT	:	begin
								out1 = ~(input3);
							end
			globals::ALU_INCS	:	begin
								out1 = input3 + 1'b1;
							end
			globals::ALU_INCA	:	begin
								out1 = acc + 1'b1;
							end
			globals::ALU_CLR	:	begin
								out1 = 0;
							end
			globals::ALU_SET	:	begin
								out1 = 1;
							end
			default			:	begin
								out1 = 0;
							end
		endcase
	end
	
endmodule
