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


endmodule
