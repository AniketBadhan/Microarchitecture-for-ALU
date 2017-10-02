`timescale 1ns/1ps

module regfile(
	input clk,
	input [3:0] input1,						//ctl_dest
	input [3:0] input2,						//ctl_sbus
	input [11:0] input3,						//ctl_address
	input [globals::WORDLEN-1:0] input4,				//data_in
	output reg [globals::WORDLEN-1:0] out = 0			//data_out
);

	reg [globals::WORDLEN-1:0] r0 = 0;
	reg [globals::WORDLEN-1:0] r1 = 0;
	reg [globals::WORDLEN-1:0] r2 = 0;
	reg [globals::WORDLEN-1:0] r3 = 0;
	reg [globals::WORDLEN-1:0] r4 = 0;
	reg [globals::WORDLEN-1:0] r5 = 0;
	reg [globals::WORDLEN-1:0] r6 = 0;
	reg [globals::WORDLEN-1:0] r7 = 0;
	
	always @ (posedge clk) begin
		if(input1 == globals::DST_R0) begin
			r0 = input4;
		end
		else begin
			r0 = r0;
		end
		if(input1 == globals::DST_R1) begin
			r1 = input4;
		end
		else begin
			r1 = r1;
		end
		if(input1 == globals::DST_R2) begin
			r2 = input4;
		end
		else begin
			r2 = r2;
		end
		if(input1 == globals::DST_R3) begin
			r3 = input4;
		end
		else begin
			r3 = r3;
		end
		if(input1 == globals::DST_R4) begin
			r4 = input4;
		end
		else begin
			r4 = r4;
		end
		if(input1 == globals::DST_R5) begin
			r5 = input4;
		end
		else begin
			r5 = r5;
		end
		if(input1 == globals::DST_R6) begin
			r6 = input4;
		end
		else begin
			r6 = r6;
		end
		if(input1 == globals::DST_R7) begin
			r7 = input4;
		end
		else begin
			r7 = r7;
		end
	end
	
	always_comb begin
		case(input2)
			globals::SBUS_R0:	begin
							out = r0;
						end
			globals::SBUS_R1:	begin
							out = r1;
						end
			globals::SBUS_R2:	begin
							out = r2;
						end
			globals::SBUS_R3:	begin
							out = r3;
						end
			globals::SBUS_R4:	begin
							out = r4;
						end
			globals::SBUS_R5:	begin
							out = r5;
						end
			globals::SBUS_R6:	begin
							out = r6;
						end
			globals::SBUS_R7:	begin
							out = r7;
						end
			globals::SBUS_ADDCONST:	begin
							out = input3;
						end
		endcase
	end

endmodule
