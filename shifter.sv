`timescale 1ns/1ps

module shifter(
		input clk,
		input [2:0] input1,													//control Bits
		input [globals::WORDLEN - 1:0] input2,							//shift_in
		output reg out1,														//zero
		output reg out2,														//carry
		output reg [globals::WORDLEN - 1:0] out3						//so
);
	
	always_comb begin
		if(input2 == 0) begin
			out1 = 1;
		end
		else begin
			out1 = 0;
		end
		
		case(input1)
			globals::SHFT_NIL:	begin
											out2 = 0;
											out3 = input2;
										end
			globals::SHFT_SHL:	begin
											out2 = input2[globals::WORDLEN-1];
											out3 = (input2 << 1);
										end
			globals::SHFT_SHR:	begin
											out2 = 0;
											out3 = (input2 >> 1);
										end
			globals::SHFT_ROL:	begin
											out2 = input2[globals::WORDLEN-1];
											out3 = {input2[14:0], input2[globals::WORDLEN-1]};
										end
			globals::SHFT_ROR:	begin
											out2 = input2[0];
											out3 = {input2[0], input2[15:1]};
										end
			globals::SHFT_SLA:	begin
											out2 = input2[globals::WORDLEN-1];
											out3 = (input2 << 1);
										end
			globals::SHFT_SRA:	begin
											out2 = 0;
											out3 = $signed(input2 >> 1);
										end
						default:		begin
											out2 = 0;
											out3 = 0;
										end
		endcase
	end

endmodule
