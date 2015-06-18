`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:		Jason Yang, Jimmy Lee
// Create Date:		14:02 06/14/2015 
// Design Name:		Game Status Controll FSM
// Module Name:		GameRAMControll 
// Project Name:	Tetris Battle
// Target Devices:	EVS 6 FPGA Demo Board
// Description:
// 		Controll the movement of the blocks and the r/w of the gaming table RAM.
// Revision: 
// 		Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module FakeDispRAMData(
	rst,
	clk_40M,
	clk_1,
	addr,
	data_out
);

	// I/O PORTS DECLARATION ----------

	// System Basic
	input rst;
	input clk_40M;
	input clk_1;

	// Display Data Output
	output reg [3:0] addr;
	output reg [9:0] data_out;

	// Counter
	reg [3:0] addr_next;

	// ADDR CONTROL ----------
	always @(posedge clk_1 or posedge rst)
	begin
		if (rst)
		begin
			addr <= 4'd0;	
		end
		else if (addr >= 4'd9)
		begin
			addr <= 4'd0;
		end
		else
		begin
			addr <= addr + 1'b1;			
		end
	end


	// FAKE DATA ----------
	always @*
	begin
		case(addr)
			4'd0: data_out = 10'b0000000001;
			4'd1: data_out = 10'b0000000010;
			4'd2: data_out = 10'b0000000100;
			4'd3: data_out = 10'b0000001000;
			4'd4: data_out = 10'b0000010000;
			4'd5: data_out = 10'b0000100000;
			4'd6: data_out = 10'b0001000000;
			4'd7: data_out = 10'b0010000000;
			4'd8: data_out = 10'b0100000000;
			4'd9: data_out = 10'b1000000000;
			default: data_out = 10'b0000000000;
		endcase
	end
endmodule
