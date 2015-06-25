`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:		Jason Yang, Jimmy Lee
// Create Date:		14:56 05/27/2015 
// Design Name:		FTSD Display
// Module Name:		ftsdDisplay
// Project Name:	Tetris Battle
// Target Devices:	EVS 6 FPGA Demo Board
// Description:
// 		Read in the controll inputs, and returns the status code.
// Revision: 
// 		Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
`include "global.v"
module ftsdDisplayChoose(
	sys_status,
	score_self_bcd,
	score_send_bcd,
	score_self,
	score_send,
	out0,
	out1,
	out2,
	out3
);

	input [2:0] sys_status;
	input [7:0] score_self_bcd, score_send_bcd;
	input [7:0] score_self, score_send;
	output reg [5:0] out0, out1, out2, out3;

	always @*
	begin
		if (sys_status == 3'b110)
		begin
			out0 = {2'b00, score_self_bcd[7:4]};
			out1 = {2'b00, score_self_bcd[3:0]};
			out2 = {2'b00, score_send_bcd[7:4]};
			out3 = {2'b00, score_send_bcd[3:0]};
		end
		else if(sys_status == 3'b111)
		begin
			if(score_self > score_send)
			begin
				out0 = `FONT_W;
				out1 = `FONT_I;
				out2 = `FONT_N;
				out3 = 6'b000000;
			end
			else
			begin
				out0 = `FONT_L;
				out1 = `FONT_O;
				out2 = `FONT_S;
				out3 = `FONT_E;
			end
		end
		else
		begin
			out0 = 6'b000000;
			out1 = 6'b000000;
			out2 = 6'b000000;
			out3 = 6'b000000;
		end
	end
endmodule