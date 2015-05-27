`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:		Jason Yang, Jimmy Lee
// Create Date:		16:36 05/27/2015 
// Design Name:		Top module
// Module Name:		tetris_battle 
// Project Name:	Tetris Battle
// Target Devices:	EVS 6 FPGA Demo Board
// Description:
// 		The top module of the game.
// Revision: 
// 		Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module tetris_battle(
	clk,
	pb_in_rst,
	pb_in_ctl,
	pb_in_vol_up,
	pb_in_vol_dwn,
	//dip_in_sound_on,
	pad_col_in,
	pad_row_scn,
	con_in_clk_sync,
	con_in_stat,
	con_in_score,
	con_in_ko,
	con_in_bomb,
	led_out,
	ftsd_out,
	speaker_out,
	// LCD whatever I don't know how to write!!
	con_out_clk_sync,
	con_out_stat,
	con_out_score,
	con_out_ko,
	con_out_bomb
);

	// I/O PORTS DECLARATION ----------

	// System Basic
	input clk;
	
	// Push Button
	input pb_in_rst, pb_in_ctl, pb_in_vol_up, pb_in_vol_dwn;
	
	// Keypad
	input [3:0] pad_col_in;
	output [3:0] pad_row_scn;

	// Display and Speaker
	output [15:0] led_out;
	output [18:0] ftsd_out;
	output [4:0] speaker_out

	// Connector In
	input con_in_clk_sync;
	input [2:0] con_in_stat;
	input [6:0] con_in_score;
	input [2:0] con_in_ko;
	input con_in_bomb;

	//Connector Out
	output con_out_clk_sync;
	output [2:0] con_out_stat;
	output [6:0] con_out_score;
	output [2:0] con_out_ko;
	output con_out_bomb;


endmodule
