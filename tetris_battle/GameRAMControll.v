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
`include "global.v"
`define STAT_CREATE			3'b000
`define STAT_STOP			3'b001
`define STAT_CLEAR			3'b010
`define STAT_MOVE_WAIT		3'b011
`define STAT_MOVE_DOWN		3'b100
`define STAT_MOVE_LEFT		3'b101
`define STAT_MOVE_RIGHT		3'b110	
`define STAT_MOVE_ROTATE	3'b111
`define RAM_WRITE			1'b1
`define RAM_READ			1'b0
`define BLOCK_O				3'b001
`define BLOCK_L				3'b010
`define BLOCK_J				3'b011
`define BLOCK_I				3'b100
`define BLOCK_S				3'b101
`define BLOCK_Z				3'b110
`define BLOCK_T				3'b111

module GameRAMControll(
	clk_40M,
	clk_1,
	rst,
	pad_key,
	pad_pressed,
	game_addLine,
	game_sendLine,
	ram_status,
	ram_addr,
	ram_data_out
);

	// I/O PORTS DECLARATION ----------

	// System Basic
	input clk_40M;
	input clk_1;
	input rst;

	// Keypad Operation
	input pad_key;
	input pad_pressed;

	// Gaming Basic Controlls
	input game_addLine;
	output game_sendLine;
	reg [2:0] state;
	reg [2:0] state_next;

	// Block Controll
	reg move_available;
	wire move_basic_check;
	reg [2:0] block_type;
	reg [6:0] block_A, block_B, block_C, block_D, block_next_A, block_next_B, block_next_C, block_next_D;
	reg [99:0] game_table;

	// RAM Controll
	output reg ram_status;
	reg 	   ram_status_next;
	output reg [3:0] ram_addr;
	reg		   [3:0] ram_addr_next;
	reg 	   [9:0] ram_data_in;
	output reg [9:0] ram_data_out;


	// BLOCK RANDOM CREATOR ---------- (Finished)
	always @(posedge clk_40M or posedge rst)
	begin
		if(rst)
		begin
			block_type<=3'b010;
		end
		else
		begin
			block_type<={block_type[1:0],block_type[2]^block_type[0]};
		end
	end

	// GAMING ----------

	// Combinational Logics
	always @*
	begin
		case(state)
			`STAT_CREATE:
			begin
				move_available = 1'b0;
				/* Create a new block */
				case(block_type)
					`BLOCK_O:{block_next_A,block_next_B,block_next_C,block_next_D} = {7'd4 ,7'd5 ,7'd14,7'd15};
					`BLOCK_L:{block_next_A,block_next_B,block_next_C,block_next_D} = {7'd25,7'd24,7'd14,7'd4 };
					`BLOCK_J:{block_next_A,block_next_B,block_next_C,block_next_D} = {7'd24,7'd25,7'd15,7'd5 };
					`BLOCK_I:{block_next_A,block_next_B,block_next_C,block_next_D} = {7'd5 ,7'd15,7'd25,7'd35};
					`BLOCK_S:{block_next_A,block_next_B,block_next_C,block_next_D} = {7'd5 ,7'd4 ,7'd14,7'd13};
					`BLOCK_Z:{block_next_A,block_next_B,block_next_C,block_next_D} = {7'd4 ,7'd5 ,7'd15,7'd16};
					`BLOCK_T:{block_next_A,block_next_B,block_next_C,block_next_D} = {7'd6 ,7'd5 ,7'd4 ,7'd15};
				endcase
				state_next = `STAT_MOVE_WAIT;
			end
			`STAT_MOVE_WAIT:
			begin
				move_available = 1'b0;
				if(1'b0) /* Force to move down UNFINISHED */
				begin
					state_next = `STAT_MOVE_DOWN;
				end
				else if(pad_key == `KEY_4) /* Press to move down */
				begin
					state_next = `STAT_MOVE_DOWN;
				end
				else if(pad_key == `KEY_1)/* Press to move left */
				begin
					state_next = `STAT_MOVE_LEFT;
				end
				else if(pad_key == `KEY_7)/* Press to move right */
				begin
					state_next = `STAT_MOVE_RIGHT;
				end
				else if (pad_key == `KEY_0)/* Press to rotate */
				begin
					state_next = `STAT_MOVE_ROTATE;
				end
				else
				begin
					state_next = `STAT_MOVE_WAIT;
				end
			end
			`STAT_MOVE_DOWN:
			begin
				/* Generate next block */
				block_next_A = block_A + 7'd10;
				block_next_B = block_B + 7'd10;
				block_next_C = block_C + 7'd10;
				block_next_D = block_D + 7'd10;
				move_available = move_basic_check;
				if(move_available)
				begin
					state_next = `STAT_MOVE_WAIT;
				end
				else
				begin
					state_next = `STAT_CREATE;
				end
			end
			`STAT_MOVE_LEFT:
			begin
				/* Generate next block */
				block_next_A = block_A - 7'd1;
				block_next_B = block_B - 7'd1;
				block_next_C = block_C - 7'd1;
				block_next_D = block_D - 7'd1;
				/* Check Movable */
				move_available = (move_basic_check && (block_A % 7'd10 != 7'd0 ) && (block_B % 7'd10 != 7'd0 ) && (block_C % 7'd10 != 7'd0 ) && (block_D % 7'd10 != 7'd0 ));

				state_next = `STAT_MOVE_WAIT;
			end
			`STAT_MOVE_RIGHT:
			begin
				/* Generate next block */
				block_next_A = block_A + 7'd1;
				block_next_B = block_B + 7'd1;
				block_next_C = block_C + 7'd1;
				block_next_D = block_D + 7'd1;
				/* Check Movable */
				move_available = (move_basic_check && ((block_A+7'd1) % 7'd10 != 7'd0 ) && ((block_B+7'd1) % 7'd10 != 7'd0 ) && ((block_C+7'd1) % 7'd10 != 7'd0 ) && ((block_D+7'd1) % 7'd10 != 7'd0 ));

				state_next = `STAT_MOVE_WAIT;
			end
			`STAT_MOVE_ROTATE:
			begin
				/* Generate next block */
					// �說
				/* Check Movable */
				state_next = `STAT_MOVE_WAIT;
			end
			default:
			begin
				move_available = 1'b0;
				state_next = `STAT_MOVE_WAIT;
			end
		endcase
	end

	// Sequential Logics
	always @(posedge clk_40M or posedge rst)
	begin
		if (rst)
		begin
			state <= `STAT_CREATE;
		end
		else
		begin
			state <= state_next;
		end
	end

	// RAM CONTROLL ----------

	// State and Address Controll - Combinational Logic (Finished)
	always @*
	begin
		if(state == `STAT_MOVE_WAIT)
		begin
			ram_status_next = `RAM_READ;
			ram_addr_next = ram_addr + 1'b1;
		end
		else
		begin
			ram_status_next = `RAM_WRITE;
		end
	end

	// State and Address Controll - Sequential Logic (Finished)
	always @(posedge clk_40M or posedge rst) begin
		if (rst) begin
			ram_status <= `RAM_WRITE;
			ram_addr <= 4'd0;
		end
		else if (ram_addr == 4'd9)
		begin
			ram_status <= ram_status_next;
			ram_addr <= 4'd0;	
		end
		else
		begin
			ram_status <= ram_status_next;
			ram_addr <= ram_addr_next;
		end
	end

	// RAM Read: Read from RAM to game table and output
	always @*
	begin
		if(ram_status == `RAM_READ)
		begin
			case(ram_addr)
				4'd0: game_table[9:0] = ram_data_out;
				4'd1: game_table[19:10] = ram_data_out;
				4'd2: game_table[29:20] = ram_data_out;
				4'd3: game_table[39:30] = ram_data_out;
				4'd4: game_table[49:40] = ram_data_out;
				4'd5: game_table[59:50] = ram_data_out;
				4'd6: game_table[69:60] = ram_data_out;
				4'd7: game_table[79:70] = ram_data_out;
				4'd8: game_table[89:80] = ram_data_out;
				4'd9: game_table[99:90] = ram_data_out;
				default: game_table = 100'd0;
			endcase
		end
	end

	// Ram Write (Finished): Save the game table to RAM
	always @*
	begin
		if(ram_status == `RAM_WRITE)
		begin
			case(ram_addr)
				4'd0: ram_data_in = game_table[9:0];
				4'd1: ram_data_in = game_table[19:10];
				4'd2: ram_data_in = game_table[29:20];
				4'd3: ram_data_in = game_table[39:30];
				4'd4: ram_data_in = game_table[49:40];
				4'd5: ram_data_in = game_table[59:50];
				4'd6: ram_data_in = game_table[69:60];
				4'd7: ram_data_in = game_table[79:70];
				4'd8: ram_data_in = game_table[89:80];
				4'd9: ram_data_in = game_table[99:90];
				default: ram_data_in = 10'd0;
			endcase
		end
	end

	// GAME TABLE CONTROLL ----------
	always @(posedge clk_40M)
	begin
		if((state[2] == 1'b1 && move_available) || (state == `STAT_CREATE))
		begin
			game_table[block_A] <= 1'b0;
			game_table[block_B] <= 1'b0;
			game_table[block_C] <= 1'b0;
			game_table[block_D] <= 1'b0;
			game_table[block_next_A] <= 1'b1;
			game_table[block_next_B] <= 1'b1;
			game_table[block_next_C] <= 1'b1;
			game_table[block_next_D] <= 1'b1;
			block_A <= block_next_A;
			block_B <= block_next_B;
			block_C <= block_next_C;
			block_D <= block_next_D;
		end
	end

	assign move_basic_check = (((block_next_A == block_A || block_next_A == block_B || block_next_A == block_C || block_next_A == block_D) && game_table[block_next_A]) || (~(block_next_A == block_A || block_next_A == block_B || block_next_A == block_C || block_next_A == block_D) && ~game_table[block_next_A])) &&
			       			  (((block_next_B == block_A || block_next_B == block_B || block_next_B == block_C || block_next_B == block_D) && game_table[block_next_B]) || (~(block_next_B == block_A || block_next_B == block_B || block_next_B == block_C || block_next_B == block_D) && ~game_table[block_next_B])) &&
					 		  (((block_next_C == block_A || block_next_C == block_B || block_next_C == block_C || block_next_C == block_D) && game_table[block_next_C]) || (~(block_next_C == block_A || block_next_C == block_B || block_next_C == block_C || block_next_C == block_D) && ~game_table[block_next_C])) &&
					 		  (((block_next_D == block_A || block_next_D == block_B || block_next_D == block_C || block_next_D == block_D) && game_table[block_next_D]) || (~(block_next_D == block_A || block_next_D == block_B || block_next_D == block_C || block_next_D == block_D) && ~game_table[block_next_D]));

endmodule
