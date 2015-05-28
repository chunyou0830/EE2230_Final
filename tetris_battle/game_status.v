`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:		Jason Yang, Jimmy Lee
// Create Date:		14:56 05/27/2015 
// Design Name:		Game Status Controll FSM
// Module Name:		gaming_status 
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

module game_status(
	pb_ctl,
	stat_sync,
	table_in,
	dip_players,
	global_clk,
	game_clk,
	stat_out
);

	// I/O PORTS DECLARATION ----------

	// Input Ports
	input pb_ctl;
	input stat_sync;
	input table_in;
	input dip_players;
	input global_clk;
	input game_clk;

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
				else if (pb_ctl && ~dip_players)
				else
			end
			`STAT_MATCH_ING:
			begin
				if(stat_sync == `STAT_MATCH_ING)
				else if(pb_ctl)
				else
			end
			`STAT_MATCH_CANCEL:
			begin
				
			end
			`STAT_MATCH_SUCCESS:
			begin
				
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