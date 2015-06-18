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
`define STAT_CREATE			3'b000
`define STAT_MOVE_WAIT		3'b001
`define STAT_MOVE_DOWN		3'b010
`define STAT_MOVE_LEFT		3'b011
`define STAT_MOVE_RIGHT		3'b100
`define STAT_MOVE_ROTATE	3'b101
`define STAT_STOP			3'b110
`define STAT_CLEAR			3'b111
`define LCD_WRITE			1'b1
`define LCD_READ			1'b0
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
	pad_key,
	pad_pressed,
	game_addLine,
	game_sendLine,
	lcd_status,
	lcd_row,
	lcd_data
);

	// I/O PORTS DECLARATION ----------

	// System Basic
	input clk_40M;
	input clk_1;

	// Keypad Operation
	input pad_key;
	input pad_pressed;

	// Gaming Basic Controlls
	input game_addLine;
	output game_sendLine;
	reg [2:0] state;
	reg [2:0] state_next;

	// Block Controll
	reg [6:0] block_type;
	reg [3:0] block_A_X, block_A_Y, block_B_X, block_B_Y, block_C_X, block_C_Y, block_D_X, block_D_Y;
	reg [99:0] game_table;
	
	// LCD Displaying
	output lcd_status;
	reg    lcd_status_next;
	output [3:0] lcd_row;
	output [9:0] lcd_data;
	reg [3:0] row_cnt;
	reg [3:0] row_cnt_next;


	// BLOCK RANDOM CREATOR ----------
	always @(posedge clk or posedge rst)
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
				/* Create a new block */
				state_next = `STAT_MOVE_WAIT;
			end
			`STAT_MOVE_WAIT:
			begin
				if(/* Force to move down */)
				begin
					state_next = `STAT_MOVE_DOWN;
				end
				else if(/* Press to move down*/)
				begin
					state_next = `STAT_MOVE_DOWN;
				end
				else if(/* Press to move left */)
				begin
					state_next = `STAT_MOVE_LEFT;
				end
				else if(/* Press to move right */)
				begin
					state_next = `STAT_MOVE_RIGHT;
				end
				else if (/* Press to rotate */)
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
				/* Check if the block can move down */
				if(/* Can move down */)
				begin
					/* Move down */
					state_next = `STAT_MOVE_WAIT;
				end
				else
				begin
					state_next = `STAT_CREATE;
				end
			end
			`STAT_MOVE_LEFT:
			begin
				/* Check if the block can move left */
				if(/* Can */)
				begin
					/* Move it */
				end
				state_next = `STAT_MOVE_WAIT
			end
			`STAT_MOVE_RIGHT:
			begin
				/* Check */
				if(/* Can */)
				begin
					/* Move it */
				end
				state_next = `STAT_MOVE_WAIT;
			end
			`STAT_MOVE_ROTATE:
			begin
				/* Check */
				if(/* Can */)
				begin
					/* Move it */
				end
				state_next = `STAT_MOVE_WAIT;
			end
			default:
			begin
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

	// LCD OUTPUT ----------

	// Combinational Logic
	always @*
	begin
		if(state == `STAT_MOVE_WAIT)
		begin
			lcd_status_next = `LCD_READ;
			row_cnt_next = row_cnt + 1'b1;
		end
		else
		begin
			lcd_status_next = `LCD_WRITE;
		end
	end

	// Sequential Logic
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			lcd_status <= `LCD_WRITE;
			row_cnt <= 4'd0;
		end
		else if (row_cnt == 4'd9)
		begin
			lcd_status <= lcd_status_next;
			row_cnt <= 4'd0;	
		end
		else
		begin
			lcd_status <= lcd_status_next;
			row_cnt <= row_cnt_next;
		end
	end

	// RAM READ AND WRITE ----------
	always @*
	begin
		if()
	end
endmodule
