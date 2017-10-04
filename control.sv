/*
	Author: Aniket Badhan
*/

`timescale 1ns/1ps

module control(
	input clk,
	input input1,					//carry
	input input2,					//zero
	output reg out1,				//ctl_ot
	output reg [3:0] out2,				//ctl_sbs
	output reg [3:0] out3,				//ctl_alu
	output reg [2:0] out4,				//ctl_shft
	output reg [3:0] out5,				//ctl_dest
	output reg [11:0] out6				//address/constant
);

	logic [31:0] cstore [9:0];
	
	assign cstore[0] = globals::O_NIL << 31 | globals::SBUS_IN << 27 | globals::ALU_PASS << 23 | globals::SHFT_NIL << 20 | globals::DST_R0 << 16 | globals::NXT_NXT << 12 | 12'b000000000000;		
	assign cstore[1] = globals::O_NIL << 31 | globals::SBUS_ADDCONST << 27 | globals::ALU_PASS << 23 | globals::SHFT_NIL << 20 | globals::DST_ACC << 16 | globals::NXT_NXT << 12 | 12'b000000000001;
	assign cstore[2] = globals::O_NIL << 31 | globals::SBUS_ADDCONST << 27 | globals::ALU_PASS << 23 | globals::SHFT_NIL << 20 | globals::DST_R1 << 16 | globals::NXT_NXT << 12 | 12'b000000000000;			//2, LCheck: (R0 - ACC) || JUMP_IF_Z Ldone
	assign cstore[3] = globals::O_NIL << 31 | globals::SBUS_ADDCONST << 27 | globals::ALU_PASS << 23 | globals::SHFT_NIL << 20 | globals::	DST_R2 << 16 | globals::NXT_NXT << 12 | 12'b000000010000;		//3, (R0-ACC) << 1 || JUMP_IF_C LSmall
	
	assign cstore[4] = globals::O_NIL << 31 | globals::SBUS_R0 << 27 | globals::ALU_AND << 23 | globals::SHFT_NIL << 20 | globals::DST_R3 << 16 | globals::NXT_JZ << 12 | 12'b000000000110;				//4, R0-ACC -> R0 || JUMP LCheck
	
	assign cstore[5] = globals::O_NIL << 31 | globals::SBUS_R1 << 27 | globals::ALU_ADD << 23 | globals::SHFT_NIL << 20 | globals::DST_R1 << 16 | globals::NXT_NXT << 12 | 12'b000000000000;			//5, ACC - R0 -> ACC || JUMP LCheck
	
	assign cstore[6] = globals::O_NIL << 31 | globals::SBUS_R2 << 27 | globals::ALU_SUBS<< 23 | globals::SHFT_NIL << 20 | globals::DST_R2 << 16 | globals::NXT_JZ << 12 | 12'b000000001000;				//6, R0 -> OUT || JUMP Lstart
	
	assign cstore[7] = globals::O_NIL << 31 | globals::SBUS_R0 << 27 | globals::ALU_PASS<< 23 | globals::SHFT_SHR << 20 | globals::DST_R0 << 16 | globals::NXT_JMP << 12 | 12'b000000000100;
	
	assign cstore[8] = globals::O_WR << 31 | globals::SBUS_R1 << 27 | globals::ALU_PASS<< 23 | globals::SHFT_NIL << 20 | globals::DST_NIL << 16 | globals::NXT_NXT << 12 | 12'b000000000000;
	assign cstore[9] = globals::O_WR << 31 | globals::SBUS_R1 << 27 | globals::ALU_PASS<< 23 | globals::SHFT_NIL << 20 | globals::DST_NIL << 16 | globals::NXT_JMP << 12 | 12'b000000000000;
	
	reg [31:0] mir;
	reg [11:0] csar = 0;
	reg [3:0] ctl_nxt = 0;
	reg [11:0] csar_nxt = 0;
	reg [11:0] ctl_address = 0;
	
	always @ (posedge clk) begin
		mir = cstore[csar];
		out1 = mir[31];
		out2 = mir[30:27];
		out3 = mir[26:23];
		out4 = mir[22:20];
		out5 = mir[19:16];
		out6 = mir[11:0];
		ctl_nxt = mir[15:12];
		ctl_address = mir[11:0];
		
		csar_nxt = csar + 1'b1; 
	end
	
	always_comb begin
		case(ctl_nxt)
			globals::NXT_NXT:	begin
							csar = csar_nxt;
						end
			globals::NXT_JMP:	begin
							csar = ctl_address;
						end
			globals::NXT_JC:	begin
							if(input1==1) begin
								csar = ctl_address;
							end
							else begin
								csar = csar_nxt;
							end
						end
			globals::NXT_JZ:	begin
							if(input2==1) begin
								csar = ctl_address;
							end
							else begin
								csar = csar_nxt;
							end
						end
			globals::NXT_JNC:	begin
							if(input1==0) begin
								csar = ctl_address;
							end
							else begin
								csar = csar_nxt;
							end
						end
			globals::NXT_JNZ:	begin
							if(input2==0) begin
								csar = ctl_address;
							end
							else begin
								csar = csar_nxt;
							end
						end
			default		:	begin
							csar = csar;
						end
		endcase
	end
		
endmodule
