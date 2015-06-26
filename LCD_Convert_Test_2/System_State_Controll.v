`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:		Jason Yang, Jimmy Lee
// Create Date:		14:56 05/27/2015 
// Design Name:		Game Status Controll FSM
// Module Name:		SystemState
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

module SystemState(
	pb_ctl,
	stat_game,
	stat_sync,
	stat_out,
	rst,
	clk_1,
	clk_100,
	led
);

	// I/O PORTS DECLARATION ----------

	// Input Ports
	input clk_1;
	input clk_100;
	input rst;
	input pb_ctl;
	input [3:0] stat_game;
	input stat_sync;

	// Output Ports
	output reg [2:0] stat_out;
	output reg [15:0] led;

	// Reg Ports
	reg [2:0] stat_out_next;
	reg [6:0] game_time;

	// COMBINATIONAL LOGICS ----------
	always @*
	begin
		case(stat_out)
			`STAT_NORMAL:
			begin
				if (pb_ctl)
				begin
					stat_out_next = `STAT_MATCH_ING;
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
				stat_out_next = `STAT_GAME_ING;
			end
			`STAT_GAME_ING:
			begin
				if(game_time == 7'd0)
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
			default:
			begin
				stat_out_next = `STAT_NORMAL;
			end
		endcase
	end

    always @(posedge clk_1 or posedge rst) 
    begin
    	if (rst) 
    	begin
    		game_time <= 7'd80;
    	end
    	else if(stat_out == `STAT_GAME_ING)
    	begin
    		game_time <= game_time - 1'd1;
    	end
    	else
    	begin
    		game_time <= 7'd80;	
    	end
    end
    reg [15:0] led_rand;
    always @(posedge clk_100 or posedge rst)
 	begin
 		if(rst)
 		begin
 			led_rand<=16'b0111_0101_0101_1010;
 		end
 		else
 		begin
 			led_rand<={led_rand[15:0],led_rand[2]^led_rand[0]};
 		end
 	end

    always @(posedge clk_1 or posedge rst) begin
    	if (rst)
    	begin
    		led <= 16'b1111_1111_1111_1111;
    	end
    	else if(stat_out == `STAT_MATCH_ING)
    	begin
    		led <= 16'b1111_1111_1111_1111;
    	end
    	/*else if(stat_out == `STAT_NORMAL)
    	begin
    		led <= led_rand;
    	end*/
    	else if (stat_out == `STAT_GAME_ING && (game_time%5) == 1'b0)
    	begin
    		led <= {led[14:0],1'b0};
    	end
    end


	always@(posedge clk_100 or posedge rst)
	if(rst)
		stat_out<=3'b0;
	else 
		stat_out<=stat_out_next;

endmodule
