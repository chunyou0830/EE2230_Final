`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:		Jason Yang, Jimmy Lee
// Create Date:		14:56 05/27/2015 
// Design Name:		Game Status Controll FSM
// Module Name:		GameStatus 
// Project Name:	Tetris Battle
// Target Devices:	EVS 6 FPGA Demo Board
// Description:
// 		Read in the controll inputs, and returns the status code.
// Revision: 
// 		Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
`define STAT_NORMAL			3'b000
`define STAT_MATCH_ING		3'b001
`define STAT_MATCH_CANCEL	3'b010
`define STAT_MATCH_SUCCESS	3'b011
`define STAT_GAME_INITIAL	3'b100
`define STAT_GAME_CNTDOWN	3'b101
`define STAT_GAME_ING		3'b110
`define STAT_GAME_OVER		3'b111

module GameStatus(
	pb_ctl,
	dip_players,
	game_over,
	game_clk,
	global_clk,
	stat_sync,
	stat_out
);

	// I/O PORTS DECLARATION ----------

	// Input Ports
	input pb_ctl;
	input dip_players;
	input game_over;
	input game_clk;
	input global_clk;
	input stat_sync;

	// Output Ports
	output reg [2:0] stat_out;

	// Reg Ports
	reg [2:0] stat_out_next;

	// COMBINATIONAL LOGICS ----------
	always @*
	begin
		case(stat_out)
			`STAT_NORMAL:
			begin
				if (pb_ctl && dip_players)
				begin
					stat_out_next = `STAT_MATCH_ING;
				end
				else if (pb_ctl && ~dip_players)
				begin
					stat_out_next = `STAT_GAME_INITIAL;
				end
				else
				begin
					stat_out_next = `STAT_NORMAL;
				end
			end
			`STAT_MATCH_ING:
			begin
				if(stat_sync == `STAT_MATCH_ING)
				begin
					stat_out_next = `STAT_MATCH_SUCCESS;
				end
				else if(pb_ctl)
				begin
					stat_out_next = `STAT_NORMAL;
				end
				else
				begin
					stat_out_next = `STAT_MATCH_ING;
				end
			end
			`STAT_MATCH_CANCEL:
			begin
				stat_out_next = `STAT_NORMAL;
			end
			`STAT_MATCH_SUCCESS:
			begin
				stat_out_next = `STAT_GAME_INITIAL;
			end
			`STAT_GAME_INITIAL:
			begin
				
			end
			`STAT_GAME_CNTDOWN:
			begin
				
			end
			`STAT_GAME_ING:
			begin
				
			end
			`STAT_GAME_OVER:
			begin
				if(pb_ctl)
				begin
					stat_out_next = `STAT_NORMAL;
				end
				else
				begin
					stat_out_next = `STAT_GAME_OVER;
				end
			end
	end