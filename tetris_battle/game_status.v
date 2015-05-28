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
	start_in,
	match_in,
	table_in,
	global_clk,
	game_clk,
	stat_out
);

	// I/O PORTS DECLARATION ----------

	// Input Ports
	input start_in;
	input match_in;
	input table_in;
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
				if (start_in)
				begin
					
				end
			end
	end