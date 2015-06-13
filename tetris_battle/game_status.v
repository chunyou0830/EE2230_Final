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
	stat_out,
	rst,
	clk_1Hz,
	KO,
	game_time
);

	// I/O PORTS DECLARATION ----------

	// Input Ports
	input game_time;
	input clk_1Hz;
	input rst;
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
    reg count_enable;
    reg [1:0] number,number_next;

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
					stat_out_next = `STAT_MATCH_CANCEL;
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
				stat_out_next = `STAT_GAME_CNTDOWN;
			end
			`STAT_GAME_CNTDOWN:
			begin
				count_enable =1'b1;
				if (number == 3) 
				begin
					stat_out_next = `STAT_GAME_ING;
				end
				else 
				begin
					stat_out_next =`STAT_GAME_CNTDOWN;
				end
			end
			`STAT_GAME_ING:
			begin
				if(KO == 5 && game_time == 0)
				begin
					stat_out_next = `STAT_GAME_OVER;
				end
				else 
				begin
					stat_out_next = `STAT_GAME_ING;	
				end
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

	always @*
	if(count_enable)
    	number_next = number + 1'b1;
    else 
    	number_next = number;

    always @(posedge clk_1Hz or posedge rst) 
    begin
    	if (rst) 
    	begin
    		number = 2'b0;
    	end
    	else 
    	begin
    		number = number_next;	
    	end
    end


	always@(posedge clk or posedge rst)
	if(rst)
		stat_out<=3'b0;
	else 
		stat_out<=stat_out_next;

endmodule
